class java::install(
        $installer = "puppet:///modules/java/jdk-6u41-linux-x64-rpm.bin"
    ) {
    @exec {
    "/usr/bin/apt-get -y update":
      alias => "aptUpdate",
      timeout => 3600;
    }
    Exec <| title == "/usr/bin/apt-get -y update"|>
    @package {
        alien:
            ensure => installed
    }
    Package<| title == alien |> <- Exec["/usr/bin/apt-get -y update"]    
    file {
        ["/root","/root/files"]:
            ensure => directory;
    }
    file {
        "/root/files/jdk-6u41-linux-x64-rpm.bin":
            source => $installer,
            mode => 0755;
    }
    exec {
        "extract-rpm":            
            command => "/root/files/jdk-6u41-linux-x64-rpm.bin",
            cwd => "/root/files",
            creates => "/root/files/jdk-6u41-linux-amd64.rpm",
            require => File["/root/files/jdk-6u41-linux-x64-rpm.bin"];           
        "alien-rpm":
            command => "/usr/bin/alien --to-deb --scripts /root/files/jdk-6u41-linux-amd64.rpm",
            cwd => "/root/files",    
            creates => "/root/files/jdk_1.6.041-1_amd64.deb",
            require => [Package["alien"],Exec["extract-rpm"]],            
            user => root;
    }

    package {
        "jdk":        
            ensure => present,
            provider => 'dpkg',
            source => "/root/files/jdk_1.6.041-1_amd64.deb",
            require => Exec["alien-rpm"];
    }
}