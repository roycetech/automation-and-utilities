#!/usr/bin/env python3.5
# Combines the pdf files inside the given folder into one.
# folder can be provided via the environment variable PYTHON_INPUT

import PyPDF2
import glob
import os


input_folder = os.environ.get('PYTHON_INPUT')
print('Processing folder: ', input_folder)

if input_folder:
    files = [os.path.join(input_folder, x)
             for x in sorted(glob.glob1(input_folder, '*.pdf'))]

    print(files)

    # Create to summation writer.
    writer = PyPDF2.PdfFileWriter()
    output_file = open(os.path.join(input_folder, 'combined.pdf'), 'wb')

    # Read each file
    for file in files:
        print(file)
        pdf_file = open(file, 'rb')
        reader = PyPDF2.PdfFileReader(pdf_file)

        # Write each file page to the summation
        for page_num in range(reader.numPages):
            page = reader.getPage(page_num)
            writer.addPage(page)

        # pdf_file.close()

    writer.write(output_file)
    output_file.close()
