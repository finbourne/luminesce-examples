import nbformat as nbf
from pathlib import Path


def magic_nb(section_dict):

    nb = nbf.v4.new_notebook()

    # Setup IPYNB file name
    nb_name = section_dict['section']

    title_string = f"""# {nb_name}

You can run the cells below directly in LUSID's JupyterHub.

The `%%luminesce` is a magic command which passes the cell query string to Lumipy,
which then returns a DataFrame.
    """

    nb['cells'].append(nbf.v4.new_markdown_cell(title_string))
    section_files = section_dict["files"]

    # Create cells with Luminesce code
    for file in section_files:

        file_header = f'#### {file[file.find("[") + 1:file.rfind("]")]}'

        nb['cells'].append(nbf.v4.new_markdown_cell(file_header))

        file_path = Path(file[file.find("(") + 1:file.rfind(")")])

        with open(file_path) as f:

            sql_code = f.read()

            luminesce_magic_cell = f"%%luminesce\n\n{sql_code}\n"

            nb['cells'].append(nbf.v4.new_code_cell(luminesce_magic_cell))

    with open(f'docs/magic-commands/{nb_name}.ipynb', 'w') as f:

        nbf.write(nb, f)

def magic_nb_builder(template_data):

    for section_dict in template_data:

        magic_nb(section_dict)

