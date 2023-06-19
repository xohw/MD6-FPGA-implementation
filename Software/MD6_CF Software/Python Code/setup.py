from cx_Freeze import setup, Executable

# List of files to be included
included_files = ['chip.ico', 'lock_b2.png']

# Executable
exe = Executable(
    script="MD6_CF.py",
    base=None,
    icon="chip.ico"  # Specify the path to the icon file
)

setup(
    name="MD6",
    version="1.0",
    description="MD6 algorithm compression function",
    executables=[exe],
    options={'build_exe': {'include_files': included_files}}
)
