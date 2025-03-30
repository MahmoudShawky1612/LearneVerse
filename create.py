import os

# List of folder paths to create
folders = [
    'lib/core/constants',

    'lib/core/utils',
    'lib/features/auth/datasources',
    'lib/features/auth/models',
    'lib/features/auth/repositories',
    'lib/features/auth/presentation/cubit',
    'lib/features/auth/presentation/views',
    'lib/features/auth/presentation/widgets',
    'lib/features/home/datasources',
    'lib/features/home/models',
    'lib/features/home/repositories',
    'lib/features/home/presentation/cubit',
    'lib/features/home/presentation/views',
    'lib/features/home/presentation/widgets',
    'lib/features/history/datasources',
    'lib/features/history/models',
    'lib/features/history/repositories',
    'lib/features/history/presentation/cubit',
    'lib/features/history/presentation/views',
    'lib/features/history/presentation/widgets',
    'lib/features/profile/datasources',
    'lib/features/profile/models',
    'lib/features/profile/repositories',
    'lib/features/profile/presentation/cubit',
    'lib/features/profile/presentation/views',
    'lib/features/profile/presentation/widgets',
]

for folder in folders:
    os.makedirs(folder, exist_ok=True)
    print(f"Created: {folder}")

print("Project folder structure created successfully.")
