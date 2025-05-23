import os

def save_files_content(folder_path, extensions, output_file):
    # Проверяем, существует ли файл и не пуст ли он
    file_exists = os.path.exists(output_file)
    
    with open(output_file, 'a', encoding='utf-8') as output:
        # Если файл не пустой, можно добавить разделитель перед началом записи
        if file_exists and os.path.getsize(output_file) > 0:
            output.write("\n" + "#" * 40 + "\n")  # Разделитель для визуального разделения блоков
        for root, dirs, files in os.walk(folder_path):
            for file in files:
                if any(file.endswith(ext) for ext in extensions):
                    file_path = os.path.join(root, file)
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        if f.readable():
                            # Пишем имя файла как комментарий
                            output.write(f"// {file}\n")
                            f.seek(0)  # Возвращаемся в начало файла, чтобы снова прочитать его
                            for line in f:
                                # Заменяем количество пробелов в начале строки, если оно кратно 4
                                leading_spaces = len(line) - len(line.lstrip(' '))
                                if leading_spaces % 4 == 0 and leading_spaces > 0:
                                    new_leading_spaces = (leading_spaces // 4) * 2
                                    line = ' ' * new_leading_spaces + line.lstrip(' ')
                                output.write(line)
                            output.write("\n\n") 

# Пример использования
folder_paths = [
     './lib/core/',
      './lib/data/',
       './lib/domain/',
        './lib/navigation/',
    './lib/features/tagging/bloc/',
    './lib/features/tagging/tasks/bounding_box/bloc/',
    './lib/features/tagging/tasks/custom/bloc/',
     './lib/features/tagging/tasks/polygon/bloc/',
       './lib/features/tagging/tasks/word_marker/bloc/',
    './lib/features/settings/bloc/',
                ]
extensions = ['.dart']  # Список нужных расширений
output_file = 'output.txt'

for ff in folder_paths:
    save_files_content(ff, extensions, output_file)
