export OMP_NUM_THREADS=8
export SOFTWARE_PATH="/home/suneth/software"

for filename in $SOFTWARE_PATH/*; do
    var_name=$(echo $filename | rev | cut -d"/" -f 1 | rev)
    var_tag=$(echo $var_name | cut -d"_" -f 1)
    if [ "$var_tag" = "kratos" ]
    then
        if [ -f "$filename/scripts/configure.sh" ]
        then
            alias ${var_name}_release_gcc="source $SOFTWARE_PATH/modules/kratos_template_module.sh $filename Release gcc"
            alias ${var_name}_release_with_debug_info_gcc="source $SOFTWARE_PATH/modules/kratos_template_module.sh $filename RelWithDebInfo gcc"
            alias ${var_name}_debug_gcc="source $SOFTWARE_PATH/modules/kratos_template_module.sh $filename Debug gcc"
            alias ${var_name}_full_debug_gcc="source $SOFTWARE_PATH/modules/kratos_template_module.sh $filename FullDebug gcc"
            alias ${var_name}_release_clang="source $SOFTWARE_PATH/modules/kratos_template_module.sh $filename Release clang"
            alias ${var_name}_release_with_debug_info_clang="source $SOFTWARE_PATH/modules/kratos_template_module.sh $filename RelWithDebInfo clang"
            alias ${var_name}_debug_clang="source $SOFTWARE_PATH/modules/kratos_template_module.sh $filename Debug clang"
            alias ${var_name}_full_debug_clang="source $SOFTWARE_PATH/modules/kratos_template_module.sh $filename FullDebug clang"
        else
            alias $var_name="source $SOFTWARE_PATH/modules/kratos_template_module.sh $filename"
        fi
    fi
done

kratos_info()
{
    echo "----------------------------------------------------"
    echo "kratos environment variables:"
    echo "---   OMP_NUM_THREADS = $OMP_NUM_THREADS"
    echo "---   KRATOS_PATH = $KRATOS_PATH"
    echo "---   KRATOS_BUILD_TYPE = $KRATOS_BUILD_TYPE"
    echo "---   KRATOS_DEFAULT_TEST_APPLICATIONS = $KRATOS_DEFAULT_TEST_APPLICATIONS"
    echo "---   KRATOS_SYNC_PATH = $KRATOS_SYNC_PATH"
    echo "---   KRATOS_TEST_PATH = $KRATOS_TEST_PATH"
    echo "----------------------------------------------------"
    echo "kratos modules:"
    for filename in $SOFTWARE_PATH/*; do
        var_name=$(echo $filename | rev | cut -d"/" -f 1 | rev)
        kratos_tag=$(echo $var_name | cut -d"_" -f 1)
        if [ $kratos_tag = "kratos" ]
        then
            temp_current_path=$(pwd)
            cd $filename
            temp_git_branch=$(git branch | grep "*" | cut -d"*" -f2)
	    if [ -f scripts/configure.sh ]
	    then
		temp_compilation="New Compilation"
	    else
                cd cmake_build
                temp_compilation=$(grep "DCMAKE_BUILD_TYPE" configure.sh | cut -d"=" -f2 | cut -d" " -f1)
	    fi
            cd $temp_current_path
            echo "---   $var_name -$temp_git_branch ($temp_compilation)"
        fi
    done
    echo "----------------------------------------------------"
    echo "kratos commands:"
    echo "---   kratos_dir : show path of currently loaded kratos module"
    echo "---   kratos_vscode : open vscode with kratos module"
    echo "---   kratos_tests : runs kratos tests"
    echo "---   kratos_tests_defaults : runs kratos tests with $KRATOS_DEFAULT_TEST_APPLICATIONS"
    echo "---   kratos_git_branch : prints git branch information"
    echo "---   kratos_git_pull : update git branch"
    echo "---   kratos_unload : unload kratos module"
    echo "---   kratos_log: opens kratos compilation log using kate"
    echo "---   kratos_paraview_output: creates xdmf file for paraview"
    echo "---   kratos_info : prints help"
    echo "---   kratos_clone_statik_head: clones $KRATOS_PATH repository to statik cluster"
    echo "---   kratos_sync_statik_head: synchronize $KRATOS_PATH repository to statik cluster"
    echo "----------------------------------------------------"
    echo "kratos commands compatible with new compilation method"
    echo "---   kratos_compile : compile kratos"
    echo "----------------------------------------------------"
    echo "kratos commands compatible with old compilation method"
    echo "---   kratos_compile_release : compile kratos in release mode"
    echo "---   kratos_compile_full_debug : compile kratos in full debug mode"
    echo "----------------------------------------------------"
}