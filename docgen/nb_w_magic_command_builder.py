import nbformat as nbf
from pathlib import Path


def magic_nb(index, section_dict):

    nb = nbf.v4.new_notebook()

    setup_file = Path(section_dict['root']).joinpath("_data").joinpath("setup.py")

    if setup_file.is_file():

        setup_md = """# Setup

You might need to run the cell below to setup data required by the Luminesce commands.
"""
        markdownId = "md" + str(index)
        codeCellId = "cc"+str(index)
        nb['cells'].append(nbf.v4.new_markdown_cell(setup_md, id=markdownId))

        with open(setup_file) as setup_file:
            setup_code = setup_file.read()
        nb['cells'].append(nbf.v4.new_code_cell(setup_code, id=codeCellId))

    nb_name = section_dict['section']

    title_string = f"""# {nb_name}

You can run the cells below directly in LUSID's JupyterHub.

The `%%luminesce` is a magic command which passes the cell query string to Lumipy,
which then returns a DataFrame.
    """
    mdTitleId = "mdt"+ str(index)
    nb['cells'].append(nbf.v4.new_markdown_cell(title_string, id=mdTitleId))

    section_files = section_dict["files"]

    # Create cells with Luminesce code

    for count, file in enumerate(section_files):

        file_header = f'#### {file[file.find("[") + 1:file.rfind("]")]}'
        mdSectionId = "mds" +str(index) + str(count)
        nb['cells'].append(nbf.v4.new_markdown_cell(file_header, id=mdSectionId))

        file_path = Path(file[file.find("(") + 1:file.rfind(")")])

        with open(file_path) as f:

            sql_code = f.read()

            codeSectionId = "ccs" + str(index) + str(count)
            luminesce_magic_cell = f"%%luminesce\n\n{sql_code}\n"

            nb['cells'].append(nbf.v4.new_code_cell(luminesce_magic_cell, id=codeSectionId))

    with open(f'docs/{nb_name}.ipynb', 'w') as f:

        nbf.write(nb, f)

def magic_nb_builder(template_data):

    for index, section_dict in enumerate(template_data):
        magic_nb(index, section_dict)