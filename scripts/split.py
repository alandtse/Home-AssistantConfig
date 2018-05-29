#!/usr/bin/env python3

# https://stackoverflow.com/questions/11313852/split-one-file-into-multiple-files-based-on-delimiter
import os
import sys
import argparse

# global settings
start_delimiter = '- id:'
end_delimiter = ''
comment_delimiter = "#"
# parse command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input-file", required=True, help="input filename")
parser.add_argument("-o", "--output-dir", required=True, help="output directory")
parser.add_argument("-s", "--start", required=False, help="start delimiter; output file name will be any text after start delimiter with input filename extension", default=start_delimiter)
parser.add_argument("-e", "--end", required=False, help="end delimiter", default=end_delimiter)
parser.add_argument("-I", "--indent", required=False, help="identation delimiter; will override --start and --end", type=int)

args = parser.parse_args()
indent = args.indent
start = args.start
input_file = args.input_file
output_dir = args.output_dir
count = 0
if (indent is not None):
    print("Splitting {} to {}/ based on indent of {}".format(input_file, output_dir, indent))
else:
    print("Splitting {} to {}/ based on start delimter of \"{}\"".format(input_file, output_dir, start))
    
if (indent is not None and indent < 0):
    print("Error: Indentation must be > 0")
    sys.exit(1)
#helper functions
def leadingspaces(string):
    return len(string) - len(string.lstrip(' '))

def foundStart(string):
    if indent is not None and indent >= 0:
        return (leadingspaces(string) == indent)
    else:
        return string.startswith(start)
def genFilename(string):
    if indent is not None and indent >= 0:
        return string.lstrip(' ').rstrip(':') + extension
    else:
        return string.replace(start, "").strip() + extension
def processString(string):
    if indent is not None and indent >= 0:
        if string.startswith(comment_delimiter):
            return string
        elif leadingspaces(string) < indent:
            return ""
        else:
            return string #string[indent:]
    else:
        return string

# read the input file
with open(input_file, 'r') as input_:
    input_data = input_.read()

# grab extension
    _, extension = os.path.splitext(input_file)
# iterate through the input data by line
input_lines = input_data.splitlines()
buffer_lines = []
while input_lines:
    # buffer lines until the next start delimiter
    while input_lines and not foundStart(input_lines[0]):
        buffer_lines.append(input_lines.pop(0))

    # corner case: no delimiter found and no more lines left
    if not input_lines:
        break

    first_line = input_lines.pop(0)
    # extract the output filename from the start delimiter
    output_filename = genFilename(first_line)
    output_path = os.path.join(args.output_dir, output_filename)

    # open the output file
    print("extracting file: {0}".format(output_path))
    count = count + 1 
    with open(output_path, 'w') as output_file:
        # write out the buffer
        while buffer_lines:
            output_file.write("{0}\n".format(processString(buffer_lines.pop(0))))
        if indent is not None and indent > 0:
            output_file.write("{0}\n".format(processString(first_line)))
        # while we have lines left and they don't match the end delimiter
        while (input_lines and not 
            ((end_delimiter and input_lines[0].startswith(end_delimiter))
                or foundStart(input_lines[0]))):
                if (not foundStart(input_lines[0])):
                        output_file.write("{0}\n".format(processString(input_lines.pop(0))))

        # remove end delimiter if present
        if input_lines and end_delimiter and input_lines[0].startswith(end_delimiter): 
            input_lines.pop(0)
print("Extracted {} files".format(count))
