# User settings
set project_name "Test_Project"
set project_dir "./Test_dir"
set part_name "xc7z020clg484-1"

file mkdir $project_dir
cd $project_dir

create_project $project_name "$project_dir" -part $part_name -force
