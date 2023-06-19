from cx_Freeze import setup, Executable

# List of files to be included
included_files = ['chip']

# Executable
exe = Executable(
    script="Test_vector.py",
    base=None,
    icon="chip.ico"  # Specify the path to the icon file
)


setup(
    name="Test vector",
    version="1.0",
    description="test of the algorithm",
    executables=[exe],
)
