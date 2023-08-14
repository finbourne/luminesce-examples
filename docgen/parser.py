import os
from pathlib import Path
import chevron


def file_to_readme_string(file):

    """
    :param file: A file name in format 'test-file.sql'
    :return: A file name for use in docs, example "Test file"
    """

    if file == "README.md":

        return file
    
    else:
    
        file_name_wout_extension = file.replace(".sql", "").capitalize()
        
        file_words = file_name_wout_extension.split("-")
                    
        if file_words[0].isdigit() and len(file_words) > 1:

            return f"Step {file_words[0]}: {file_words[1].capitalize()} {' '.join(file_words[2:])}"
            
        else:
            
            return " ".join(file_words)
    


def generate_markdown_hyperlink(sub_dir, file):

    """
    :param project_name: The project name
    :param root: The root folder for the SQL examples
    :param file: The SQL file name
    :return: A string which represents file name and hyperlink for markdown
    """

    file_name_for_markdown = file_to_readme_string(Path(file).name)

    print(file_name_for_markdown)

    rel_path = os.path.join(sub_dir, file)

    return f"[{file_name_for_markdown}]({rel_path})"


def collect_files_for_readme(source):

    """
    :param source: A source directory (i.e. where to start looking for files)
    :return: A list of files and paths
    """

    files_and_paths = []

    for root, dirs, files in os.walk(source):

        sql_files = [i for i in files if i.endswith(".sql")]

        if len(sql_files) > 0:

            files_and_paths.append([root, dirs, files])

    return files_and_paths


def build_mustache_data(files_in_scope, project_name):

    """

    :param files_in_scope: These are the files and dirs in scope
    :param project_name: The main project name
    :return: A list of dicts which can be passed to the mustache template
    """
    
    file_data_for_template = []

    project_name = "luminesce-examples"

    for (root, dir, files) in files_in_scope:
        
        section_data = {}

        sub_dir = root[root.rfind(project_name) + len(project_name) + 1:]

        section_data["section"] = file_to_readme_string(Path(sub_dir).name)

        section_data["files"] = [generate_markdown_hyperlink(
            sub_dir,
            file)
            for file in sorted(files)]

        file_data_for_template.append(section_data)

    return file_data_for_template

def generate_template(template_data):

    """
    :param template_data: A list of dics used to generate markdown
    :return: A markdown file
    """

    template = "docgen/README.mustache"

    with open(template, 'r') as f:

        return chevron.render(f, {'file_data': template_data})


if __name__ == "__main__":
    
    # Path variables
    PROJECT_NAME = "luminesce-examples"
    root = Path(__file__).parent.parent.resolve()
    readme_path = os.path.join(root, "README.md")
    examples_path = root.joinpath("examples")

    # Collect the SQL files only, ignore other config files
    files_in_scope = collect_files_for_readme(examples_path)
    
    # Build a list of data required for mustache template
    template_data = build_mustache_data(files_in_scope, PROJECT_NAME)

    # Generate template
    md_file = generate_template(template_data)

    with open(readme_path, "w") as file:
        file.write(md_file)
