class java::install {
        exec {
    "/usr/bin/apt-get -y update":
      alias => "aptUpdate",
      timeout => 3600;
  }
    package {
        "alien":
            ensure => installed,
            require => Exec["aptUpdate"];
    }

    file {
        "/tmp/jre-6u41-linux-x64-rpm.bin":
            source => "puppet:///modules/java/jre-6u41-linux-x64-rpm.bin",
            mode => 0755;
    }
    exec {
        "extract-rpm":            
            command => "/tmp/jre-6u41-linux-x64-rpm.bin",
            cwd => "/tmp",
            require => File["/tmp/jre-6u41-linux-x64-rpm.bin"];           
        "alien-rpm":
            command => "/usr/bin/alien --to-deb --scripts /tmp/jre-6u41-linux-amd64.rpm",
            cwd => "/tmp",    
            require => [Package["alien"],Exec["extract-rpm"]],            
            user => root;
    }

    package {
        "java":        
            ensure => installed,
            provider => 'dpkg',
            source => "/tmp/jre_1.6.041-1_amd64.deb",
            require => Exec["alien-rpm"];
    }
}