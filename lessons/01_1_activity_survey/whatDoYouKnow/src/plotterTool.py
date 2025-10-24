#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Quick and dirty interactive Plotly plotter for CSV files

# Plotting command:
# python3 plotterTool.py example.csv --plot scatter --x word --y count



import argparse
import pandas as pd
import plotly.express as px
import os

def parse_args():
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description="Interactive Plotly Plotter for CSV files")
    parser.add_argument("csv_file", help="Path to the CSV or TXT file containing data")
    parser.add_argument("--plot", choices=["histogram", "scatter"], required=True, help="Type of plot to generate")
    parser.add_argument("--x", required=True, help="Column name for x-axis")
    parser.add_argument("--y", help="Column name for y-axis (required for scatter)")
    parser.add_argument("--output", default="plot.html", help="Output HTML file for the plot")
    return parser.parse_args()

def detect_delimiter(file_path):
    """Detect delimiter (tab or comma) in the file."""
    with open(file_path, 'r') as f:
        lines = [line for line in f if line.strip()]
    sample = ''.join(lines[:10])
    delimiter = '\t' if '\t' in sample else ','
    return delimiter, lines

def load_data(file_path, delimiter, lines):
    """Load data into DataFrame, assign column names, and clean data."""
    first_line = lines[0].strip()
    columns = first_line.split(delimiter)
    # If all columns are numbers, assume no header and assign default names
    if all(c.replace('.', '', 1).isdigit() for c in columns):
        df = pd.read_csv(file_path, sep=delimiter, header=None, names=['word', 'count'])
    else:
        df = pd.read_csv(file_path, sep=delimiter, names=['word', 'count'])
    # Remove any rows with missing or empty values
    df = df.dropna()
    df = df[(df['word'].astype(str).str.strip() != '') & (df['count'].astype(str).str.strip() != '')]
    return df

def generate_plot(df, plot_type, x, y=None):
    """Generate the requested plot using Plotly."""
    if plot_type == "histogram":
        fig = px.histogram(df, x=x)
    elif plot_type == "scatter":
        if y is None:
            raise ValueError("--y is required for scatter plot")
        fig = px.scatter(df, x=x, y=y)
    else:
        raise ValueError("Invalid plot type")
    return fig

def serialize_output_filename(output_file):
    """Serialize output filename if it already exists."""
    if os.path.exists(output_file):
        base, ext = os.path.splitext(output_file)
        i = 1
        while True:
            new_file = f"{base}_{i:02d}{ext}"
            if not os.path.exists(new_file):
                return new_file
            i += 1
    return output_file

def main():
    args = parse_args()
    delimiter, lines = detect_delimiter(args.csv_file)
    df = load_data(args.csv_file, delimiter, lines)
    try:
        fig = generate_plot(df, args.plot, args.x, args.y)
    except ValueError as e:
        print(f"Error: {e}")
        return
    output_file = serialize_output_filename(args.output)
    fig.write_html(output_file)
    print(f"Plot saved to {output_file}. Open it in your browser to view.")

if __name__ == "__main__":
    main()
