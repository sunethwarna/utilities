export KRATOS_PATH=$1
export KRATOS_BUILD_TYPE=$2
export KRATOS_DEFAULT_TEST_APPLICATIONS="FluidDynamicsApplication"
export KRATOS_SYNC_PATH="applications/RANSApplication"
export KRATOS_TEST_PATH=$(pwd)
export OMP_NUM_THREADS=10

echo "***********************************************************"
if [ -f "$KRATOS_PATH/scripts/configure.sh" ]
then
    echo "      New Compilation Environment Initialized at:     "
    export KRATOS_BUILD_PATH=${KRATOS_PATH}/bin/${KRATOS_BUILD_TYPE}
else
    echo "      Old Compilation Environment Initialized at:     "
    export KRATOS_BUILD_PATH=$KRATOS_PATH
fi
echo "       $KRATOS_PATH"
echo "**********************************************************"

export PATH=$KRATOS_BUILD_PATH:$PATH
export LD_LIBRARY_PATH=$KRATOS_BUILD_PATH/libs:$LD_LIBRARY_PATH
export PYTHONPATH=$KRATOS_BUILD_PATH:$PYTHONPATH

kratos_clone_statik_head()
{
    echo "---- Cloning kratos at $KRATOS_PATH ----"
    echo "-------- Creating compressed archive..."
    current_pwd=$(pwd)
    kratos_name=$(echo $KRATOS_PATH | rev | cut -d"/" -f1 | rev)
    cd ~/software
    if [ -f "kratos_statik_cluster_ssh.zip" ]
    then
        rm -f kratos_statik_cluster_ssh.zip
    fi
    zip -rq kratos_statik_cluster_ssh.zip $kratos_name -x $kratos_name/bin/**\* $kratos_name/build/**\* -x $kratos_name/.git/**\* -x$kratos_name/.vscode/**\*
    echo "-------- Copying archive..."
    scp ~/software/kratos_statik_cluster_ssh.zip sunethw@head.st.bv.tum.de:~/software/
    rm -f kratos_statik_cluster_ssh.zip
    echo "-------- Expanding archive..."
    ssh sunethw@head.st.bv.tum.de "cd ~/software/ && if [ -d $kratos_name ]; then rm -rf $kratos_name; fi && unzip -q kratos_statik_cluster_ssh.zip && rm -f kratos_statik_cluster_ssh.zip && cp modules/kratos_configure.sh.orig $kratos_name/scripts/configure.sh && echo $(date "+%Y-%m-%d %H:%M:%S") > $kratos_name/clone_time_stamp.dat"
    cd $current_pwd
}

kratos_sync_statik_head()
{
    echo "---- Synching kratos at $KRATOS_PATH ----"
    kratos_name=$(echo $KRATOS_PATH | rev | cut -d"/" -f1 | rev)
    echo "------- Synching applications"
    rsync -avurcz $KRATOS_PATH/applications/ sunethw@head.st.bv.tum.de:~/software/$kratos_name/applications/
    echo "------- Synching kratos"
    rsync -avurcz $KRATOS_PATH/kratos/ sunethw@head.st.bv.tum.de:~/software/$kratos_name/kratos/
    echo "------- Synching external_libraries"
    rsync -avucrz $KRATOS_PATH/external_libraries/ sunethw@head.st.bv.tum.de:~/software/$kratos_name/external_libraries/
    ssh sunethw@head.st.bv.tum.de "echo $(date "+%Y-%m-%d %H:%M:%S") > ~/software/$kratos_name/clone_time_stamp.dat"
}

kratos_clone_bridge()
{
    echo "---- Cloning kratos at $KRATOS_PATH ----"
    echo "-------- Creating compressed archive..."
    current_pwd=$(pwd)
    kratos_name=$(echo $KRATOS_PATH | rev | cut -d"/" -f1 | rev)
    cd ~/software
    if [ -f "kratos_bridge_ssh.zip" ]
    then
        rm -f kratos_bridge_ssh.zip
    fi
    zip -rq kratos_bridge_ssh.zip $kratos_name -x $kratos_name/bin/**\* $kratos_name/build/**\* -x $kratos_name/.git/**\* -x$kratos_name/.vscode/**\*
    echo "-------- Copying archive..."
    scp ~/software/kratos_bridge_ssh.zip suneth@roompc-next4.st.bv.tum.de:~/software/
    rm -f kratos_bridge_ssh.zip
    echo "-------- Expanding archive..."
    ssh suneth@roompc-next4.st.bv.tum.de "cd ~/software/ && if [ -d $kratos_name ]; then rm -rf $kratos_name; fi && unzip -q kratos_bridge_ssh.zip && rm -f kratos_bridge_ssh.zip && echo $(date "+%Y-%m-%d %H:%M:%S") > $kratos_name/clone_time_stamp.dat"
    cd $current_pwd
}

kratos_sync_bridge()
{
    echo "---- Synching kratos at $KRATOS_PATH ----"
    kratos_name=$(echo $KRATOS_PATH | rev | cut -d"/" -f1 | rev)
    echo "------- Synching applications"
    rsync -avurcz $KRATOS_PATH/applications/ suneth@roompc-next4.st.bv.tum.de:~/software/$kratos_name/applications/
    echo "------- Synching kratos"
    rsync -avurcz $KRATOS_PATH/kratos/ suneth@roompc-next4.st.bv.tum.de:~/software/$kratos_name/kratos/
    echo "------- Synching external_libraries"
    rsync -avucrz $KRATOS_PATH/external_libraries/ suneth@roompc-next4.st.bv.tum.de:~/software/$kratos_name/external_libraries/
    ssh sunethw@head.st.bv.tum.de "echo $(date "+%Y-%m-%d %H:%M:%S") > ~/software/$kratos_name/clone_time_stamp.dat"
}

kratos_info

alias kratos_dir="echo $KRATOS_PATH"
alias kratos_vscode="code $KRATOS_PATH"
alias kratos_tests='current_path=$(pwd) && cd $KRATOS_PATH/kratos/python_scripts && python run_tests.py -c python -v2 && cd $current_path || cd $current_path'
alias kratos_tests_defaults='current_path=$(pwd) && cd $KRATOS_PATH/kratos/python_scripts && python run_tests.py -a $KRATOS_DEFAULT_TEST_APPLICATIONS -v2 -c python && cd $current_path || cd $current_path'
alias kratos_git_branch='current_path=$(pwd) && cd $KRATOS_PATH && git branch && cd $current_path || cd $current_path'
alias kratos_git_pull='current_path=$(pwd) && cd $KRATOS_PATH && git pull && cd $current_path || cd $current_path'
alias kratos_paraview_output='python $KRATOS_PATH/applications/HDF5Application/python_scripts/create_xdmf_file.py'

if [ -f "$KRATOS_PATH/scripts/configure.sh" ]
then
    alias kratos_log='kate $KRATOS_PATH/build$KRATOS_BUILD_TYPE/kratos.compile.log'
    alias kratos_compile_configuration='kate $KRATOS_PATH/scripts/configure.sh'
    alias kratos_compile='current_path=$(pwd) && cd $KRATOS_PATH/scripts && unbuffer sh configure.sh 2>&1 | tee kratos.compile.log && cd $current_path || cd $current_path'
    alias kratos_compile_clean='current_path=$(pwd) && rm -rf $KRATOS_PATH/build/$KRATOS_BUILD_TYPE $KRATOS_PATH/bin/$KRATOS_BUILD_TYPE cd $current_path || cd $current_path'    
    alias kratos_unload='export PATH="${PATH//"$KRATOS_BUILD_PATH:"/}" && export LD_LIBRARY_PATH="${LD_LIBRARY_PATH//"$KRATOS_BUILD_PATH/libs:"/}" && export PYTHONPATH="${PYTHONPATH//"$KRATOS_BUILD_PATH:"/}" && export KRATOS_DEFAULT_TEST_APPLICATIONS="" && export KRATOS_BUILD_PATH="" && unalias kratos_dir kratos_tests kratos_tests_defaults kratos_git_branch kratos_git_pull kratos_unload kratos_vscode kratos_compile kratos_paraview_output kratos_compile_configuration'    
else
    alias kratos_log='kate $KRATOS_PATH/cmake_build/kratos.compile.log'
    alias kratos_compile_configuration='kate $KRATOS_PATH/cmake_build/configure.sh'
    alias kratos_compile_full_debug='current_path=$(pwd) && cd $KRATOS_PATH/cmake_build && sed -i -e "s/-DCMAKE_BUILD_TYPE=Release/-DCMAKE_BUILD_TYPE=FullDebug/g" configure.sh && unbuffer sh $KRATOS_PATH/cmake_build/configure.sh 2>&1 | tee kratos.compile.log && cd $current_path || cd $current_path'
    alias kratos_compile_release='current_path=$(pwd) && cd $KRATOS_PATH/cmake_build && sed -i -e "s/-DCMAKE_BUILD_TYPE=FullDebug/-DCMAKE_BUILD_TYPE=Release/g" configure.sh && unbuffer sh $KRATOS_PATH/cmake_build/configure.sh 2>&1 | tee kratos.compile.log && cd $current_path || cd $current_path'
    alias kratos_compile_clean='current_path=$(pwd) && cd $KRATOS_PATH/cmake_build && mv configure.sh .. && mv README.md .. && rm -rf * && mv ../configure.sh . && mv ../README.md . && cd $current_path || cd $current_path'    
    alias kratos_unload='export PATH="${PATH//"$KRATOS_BUILD_PATH:"/}" && export LD_LIBRARY_PATH="${LD_LIBRARY_PATH//"$KRATOS_BUILD_PATH/libs:"/}" && export PYTHONPATH="${PYTHONPATH//"$KRATOS_BUILD_PATH:"/}" && export KRATOS_DEFAULT_TEST_APPLICATIONS="" && export KRATOS_BUILD_PATH="" && unalias kratos_dir kratos_tests kratos_tests_defaults kratos_git_branch kratos_git_pull kratos_unload kratos_vscode kratos_compile_full_debug kratos_compile_release kratos_paraview_output kratos_compile_configuration'    
fi
