import nbformat as nbf
from pathlib import Path


def build_nb(section_dict):

    nb = nbf.v4.new_notebook()

    # Setup IPYNB file name
    nb_name = section_dict['section']
    nb['cells'].append(nbf.v4.new_markdown_cell(f"# {nb_name}"))
    section_files = section_dict["files"]

    # Create cells with Luminesce code
    for file in section_files:

        file_header = f'#### {file[file.find("[") + 1:file.rfind("]")]}'

        nb['cells'].append(nbf.v4.new_markdown_cell(file_header))

        file_path = Path(file[file.find("(") + 1:file.rfind(")")])

        with open(file_path) as f:

            sql_code = f.read()

            sql_markdown = f"```sql\n{sql_code}\n```"

            nb['cells'].append(nbf.v4.new_markdown_cell(sql_markdown))

    with open(f'docs/{nb_name}.ipynb', 'w') as f:

        nbf.write(nb, f)

def nb_builder(template_data):

    for section_dict in template_data:

        build_nb(section_dict)

