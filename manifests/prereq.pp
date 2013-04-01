class java::prereq {
    if !defined(Package[alien]) {
        package {
            "alien":
                ensure => installed
        }        
    }

}