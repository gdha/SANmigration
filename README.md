# SANmigration HP StorageArray XP devices

The purpose of these tools are to create a snapshot of the current non-vg00 SAN Volume Groups and afterwards being able to recreate the complete SAN layout from scratch. However, it requires the same amount (and sized) SAN disks on the new SAN box. Therefore, two scripts (and and subdirectory with functions) were created to handle these tasks in a semi-automated way.

To save the SAN layout of the source system just run:

    #-> ./save_san_layout.sh -h
    Usage: save_san_layout.sh [-f SAN_layout_configuration_file] [-k] [-h]
    
    -f file: The SAN_layout_configuration_file to store in SAN layout in
    -k:      Keep the temporary directory after we are finished executing save_san_layout.sh
    -d:      Enable debug mode (by default off)
    -h:      Show usage [this page]
    
Copy the /tmp/SAN_layout_of<system>.conf file to the target system and run:

    #-> ./create_san_layout_script.sh -f ./SAN_layout_of_hpx217.conf -h
    Usage: create_san_layout_script.sh [-f SAN_layout_configuration_file] [-s create_SAN_layout.sh] [-p percentage] [-k] [-h] [-d]
    
    -f file:   The SAN_layout_configuration_file containing the SAN layout of hpx208bi
    -s script: The name of the SAN creation script
    -p nr:     A percentage (integer) value which is allowed in deviation of the target disk sizes
    -k:        Keep the temporary directory after we are finished executing create_san_layout_script.sh
    -h:        Show usage [this page]
    -d:        Enable debug mode (by default off)
    


