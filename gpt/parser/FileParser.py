import os
import re
from os.path import join


class FileParser:

    NORMAL = 0
    PARLAI_FORMAT_TXT = 1
    PARLAI_FORMAT_JSON = 2
    GPT_JSONL = 3

    def __init__(self, source_folder: str, source_file: str, destination_folder: str, destination_file: str, format: int):
        self.source_folder = source_folder
        self.source_file = source_file
        self.destination_folder = destination_folder
        self.destination_file = destination_file
        self.format = format

    def parse(self):
        # self.save_file_as_txt(self.parse_file())
        self.append_values_to(self.parse_file(), join(
            self.destination_folder, self.destination_file))

    def parse_file(self):
        f = self.find_file(path=join(self.source_folder, self.source_file))
        first_line = 0
        previous_role = None
        values = []
        for line in f:
            if first_line == 0:
                first_line += 1
                continue
            if first_line <= 2:
                first_line += 1
                if '<synch>' in line or 'sync' in line or '[sync]' in line:
                    continue
            res = self.parse_line(line, previous_role)
            if res is None:
                continue
            previous_role = res['role']
            if res['merge']:
                values[-1].append_to_message(res['value'])
            else:
                values.append(MessagePair(res['role'], res['value']))
        f.close()
        return values

    def parse_line(self, line: str, previous_role: str):
        if line is None or line == '' or line == '\n':
            return None
        line = line.replace('\n', '')
        res = line.split('\t')
        match = re.search(r'\((.*?)\)', res[3])
        if match:
            res[3] = match.group(1)
            res[3] = res[3].replace('(', '')
            res[3] = res[3].replace(')', '')
        res_obj = {'merge': False, 'role': res[2], 'value': res[3]}
        if res[2] == previous_role:
            res_obj['merge'] = True
        return res_obj

    def find_file(self, path: str):
        return open(path, mode='r')

    def save_file_as_txt(self, values: list):
        file_path = join(self.destination_folder,
                         self.convert_name_to_txt(self.destination_file))
        des_file = open(file_path, 'a')
        l = len(values)
        i = 0
        while True:
            if self.format == self.NORMAL:
                temp = f"{values[i].message}\t{values[i+1].message}"
            elif self.format == self.PARLAI_FORMAT_TXT:
                try:
                    temp = f"text:{values[i].message}\tlabels:{values[i+1].message}"
                except:
                    temp = f"text:{values[i].message}\tlabels:"

            i = i + 2
            des_file.write(temp)
            if i >= l:
                if self.format == self.PARLAI_FORMAT_TXT:
                    des_file.write('\tepisode_done:True\n')
                break
            des_file.write('\n')
        des_file.close()

    def append_values_to(self, values: list, file_path):
        des_file = open(file_path, 'a')
        l = len(values)
        i = 0
        while True:
            if self.format == self.NORMAL:
                temp = f"{values[i].message}\t{values[i+1].message}"
            elif self.format == self.PARLAI_FORMAT_TXT:
                try:
                    temp = f"text:{values[i].message}\tlabels:{values[i+1].message}"
                except:
                    temp = f"text:{values[i].message}\tlabels:"
            elif self.format == self.GPT_JSONL:
                # {"prompt": "<prompt text>", "completion": "<ideal generated text>"}
                # temp = f"{'prompt': '{values[i+1].message}', 'completion': '{values[i].message}'}"
                try:
                    temp = "{\"prompt\": \""+values[i+1].message + \
                        "\", \"completion\": \""+values[i].message+"\"}"
                except:
                    temp = "{\"prompt\": \""+"---" + \
                        "\", \"completion\": \""+values[i].message+"\"}"

            i = i + 2
            des_file.write(temp)
            des_file.write('\n')
            if i >= l:
                if self.format == self.PARLAI_FORMAT_TXT:
                    des_file.write('\tepisode_done:True\n')
                break
        des_file.close()

    def convert_name_to_txt(self, name: str):
        return name.replace('.csv', '.txt')


class MessagePair:
    def __init__(self, role, message):
        self.role = role
        self.message = message

    def append_to_message(self, value):
        self.message = self.message + ", " + value

    def __str__(self) -> str:
        return f"Role: {self.role} \t Message: {self.message}"
