#!/usr/bin/env python3
#
#    ios.py: build Verilog module IO and documentation
#

from verilog2tex import write_table
import if_gen

# Return full port type string based on given types: "I", "O" and "IO"
# Maps "I", "O" and "IO" to "INPUT", "OUTPUT" and "INOUT", respectively.
def get_port_type(port_type):
    if port_type == "I":
        return "INPUT"
    elif port_type == "O":
        return "OUTPUT"
    else:
        return "INOUT"

# Generate io.vh file
# ios: list of tables, each of them containing a list of ports
# Each table is a dictionary with fomat: {'name': '<table name>', 'descr':'<table description>', 'ports': [<list of ports>]}
# Each port is a dictionary with fomat: {'name':"<port name>", 'type':"<port type>", 'n_bits':'<port width>', 'descr':"<port description>"},
def generate_ios_header(ios, out_dir):
    f_io = open(f"{out_dir}/io.vh", "w")

    for table in ios:
        # Check if this table is a standard interface (from if_gen.py)
        if table['name'] in if_gen.interfaces:
            # Interface is standard, generate ports
            if_gen.create_signal_table(table['name'])
            if_gen.write_vh_contents(table['name'], '', '', f_io)
        else:
            # Interface is not standard, read ports
            for port in table['ports']:
                f_io.write(f"`IOB_{get_port_type(port['type'])}({port['name']}, {port['n_bits']}), //{port['descr']}\n")

    f_io.close()

# Generate TeX tables of IOs
def generate_ios_tex(ios, out_dir):
    for table in ios:
        tex_table = []
        # Check if this table is a standard interface (from if_gen.py)
        if table['name'] in if_gen.interfaces:
            # Interface is standard, generate ports
            if_gen.create_signal_table(table['name'])
            for port in if_gen.table:
                port_direction = port['signal'] if 'm_' in port['name'] else if_gen.reverse(port['signal']) # Reverse port direction if it is a slave interface
                tex_table.append([(port['name']+if_gen.suffix(port_direction)).replace('_','\_'),
                                  port_direction.replace('`IOB_','').replace('(',''),
                                  port['width'].replace('_','\_'),
                                  port['description']])
        else:
            # Interface is not standard, read ports
            for port in table['ports']:
                tex_table.append([port['name'].replace('_','\_'),get_port_type(port['type']),port['n_bits'].replace('_','\_'),port['descr']])

        write_table(f"{out_dir}/{table['name']}",tex_table)
