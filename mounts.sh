mount_remote_dirs()
{

fusermount -u /mnt/suneth/Network/StatikCluster &> /dev/null
fusermount -u /mnt/suneth/Network/StatikBridgePC &> /dev/null
fusermount -u /mnt/suneth/Network/StatikTestHome &> /dev/null
fusermount -u /mnt/suneth/Network/StatikTestProjects &> /dev/null

sshfs suneth@roompc-next4.st.bv.tum.de:/home/suneth/ /mnt/suneth/Network/StatikBridgePC/
sshfs sunethw@head.st.bv.tum.de:/home/sunethw/ /mnt/suneth/Network/StatikCluster/
sshfs sunethw@129.187.141.45:/home/sunethw/ /mnt/suneth/Network/StatikTestHome
sshfs sunethw@129.187.141.45:/media/2TBTwo/sunethw/ /mnt/suneth/Network/StatikTestProjects
}
