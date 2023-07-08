import shutil
import sys
from os import listdir
from os.path import isfile, join

from FileParser import FileParser


class ParserRunner:
    def __init__(self, source_folder: str, destination_folder: str,
                 format: int, erase_file: bool,
                 multi_file: bool, training_per: float):
        self.source_folder = source_folder
        self.destination_folder = destination_folder
        self.format = format
        self.erase_file = erase_file
        self.multi_file = multi_file
        self.training_per = training_per

    def run(self):
        print('Started Parsing...\n')
        train_des = join(self.destination_folder, "_train.txt")
        test_des = join(self.destination_folder, "_test.txt")
        valid_des = join(self.destination_folder, "_valid.txt")
        if self.erase_file == '1':
            open(train_des, 'w').truncate()
            open(test_des, 'w').truncate()
            open(valid_des, 'w').truncate()
        all_files = listdir(self.source_folder)
        number_of_training_files = float(
            len(all_files)) * float(self.training_per)
        i = 0
        for f in sorted(all_files):
            print(f"{f}\t|\t Is file ({isfile(join(self.source_folder, f))})")
            if isfile(join(self.source_folder, f)):
                print(f"Parsing ({f})")
                dest_f = f
                if self.multi_file == '0':
                    dest_f = '_train.txt'
                    if i >= number_of_training_files:
                        dest_f = '_test.txt'
                fp = FileParser(self.source_folder, f,
                                self.destination_folder, dest_f,
                                self.format)
                fp.parse()
                i += 1
        shutil.copy(join(self.destination_folder, '_test.txt'),
                    join(self.destination_folder, '_valid.txt'))
        print('\nFinished!')

    def runJSONL(self):
        print('Started Parsing...\n')
        train_des = join(self.destination_folder, "_train.jsonl")
        test_des = join(self.destination_folder, "_test.jsonl")
        if self.erase_file == '1':
            open(train_des, 'w').truncate()
            open(test_des, 'w').truncate()
        all_files = listdir(self.source_folder)
        number_of_training_files = float(
            len(all_files)) * float(self.training_per)
        i = 0
        for f in sorted(all_files):
            print(f"{f}\t|\t Is file ({isfile(join(self.source_folder, f))})")
            if isfile(join(self.source_folder, f)):
                print(f"Parsing ({f})")
                dest_f = f
                if self.multi_file == '0':
                    dest_f = '_train.jsonl'
                    if i >= number_of_training_files:
                        dest_f = '_test.jsonl'
                fp = FileParser(self.source_folder, f,
                                self.destination_folder, dest_f,
                                self.format)
                fp.parse()
                i += 1
        print('\nFinished!')


def parse_arguments():
    args = ' '.join(sys.argv).split('-')
    format = FileParser.NORMAL
    multi_file = 1
    erase_file = 1
    for i in range(1, len(args)):
        temp = args[i].split(' ')
        # Format
        if temp[0] == 'f':
            if int(temp[1]) >= FileParser.NORMAL and int(temp[1]) <= FileParser.GPT_JSONL:
                format = int(temp[1])
            else:
                print("Unknown argument")
                return None, None, None, None

        # Erase
        elif temp[0] == 'e':
            if int(temp[1]) == 0 or int(temp[1]) == 1:
                erase_file = temp[1]
            else:
                print("Unknown argument")
                return None, None, None, None
        # Multiple files
        elif temp[0] == 'm':
            if int(temp[1]) == 0 or int(temp[1]) == 1:
                multi_file = temp[1]
            else:
                print("Unknown argument")
                return None, None, None, None
        # Training percentage
        elif temp[0] == 'p':
            if float(temp[1]) >= 0 or float(temp[1]) <= 1:
                training_per = temp[1]
            else:
                print("Unknown argument")
                return None, None, None, None

    return format, erase_file, multi_file, training_per


if __name__ == "__main__":
    result = parse_arguments() or (None, None, None, None)
    format, erase_file, multi_file, training_per = result if result is not None else (
        None, None, None, None)
    # FileParser('data/unparsed', '479_TRANSCRIPT.csv',
    #            'data/parsed', 'temp.txt', 1).parse()
    ParserRunner('data/unparsed',
                 'data/parsed', format, erase_file, multi_file, training_per).runJSONL()
