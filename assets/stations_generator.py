import csv;

stations = []

with open('stations.csv') as file:
    csv_reader = csv.reader(file, delimiter=',')

    line_count = 0
    for line in csv_reader:
        if line_count == 0:
            line_count += 1
            continue
        else:
            line_count += 1
            stations.append([line[0], line[1], line[2], line[3]])

generated_file = """import 'package:flutter/material.dart';

import 'station.dart';

const List<Station> stations = [
"""

for station in stations:
    generated_file += f"  Station(\"{station[0]}\", {station[1]}, {station[2]}, \"{station[3]}\"),\n"

generated_file += '];'

generated_file += """
const List<DropdownMenuEntry> homeStationEntries = [
"""

for station in stations:
    generated_file += f"  DropdownMenuEntry(value: \"{station[3]}\", label: \"{station[0]} ({station[3]})\"),\n"

generated_file += '];'

with open('../lib/classes/station_list.g.dart', 'w') as file:
    file.write(generated_file)

print("Written to ../lib/station_list.g.dart")