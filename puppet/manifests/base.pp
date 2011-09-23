group { "puppet":
  ensure => "present",
}

package { "curl":
  ensure => present,
}

Exec {
  path => ["/bin", "/usr/bin"],
  user => 'root'
}

class mongo_db_manual_install {
  # ===================
  # = Install mongodb =
  # ===================
  # TODO: use code below to install mongodb from source if not on ubuntu
  $mongo_version = "2.0.0"
  $arch_for_mongo = $architecture ? { # mongo uses i686 for i386
          i386 => 'i686',
          default => $architecture,
      }
  $mongo_release_name = "mongodb-linux-$arch_for_mongo-$mongo_version"
  $mongo_url = "http://downloads.mongodb.org/linux/$mongo_release_name.tgz"
  $mongo_dir = "/mongo"

  exec { "launch mongo":
    command => "bash -l -i -c 'mongod --fork --dbpath $mongo_dir/data/db --logpath $mongo_dir/log/mongodb.log'",
    require => Exec["install mongo"]
  }

  exec { "install mongo":
    unless => "which mongo",
    cwd => '/tmp',
    require => Package["curl"],
    command => "curl $mongo_url > mongo.tgz && tar xzf mongo.tgz && mv $mongo_release_name $mongo_dir && ln -nfs /mongo/bin/* /usr/bin/"
  }

  # create db dir, log dir & log file
  exec { "create mongo files":
    command => "mkdir -p $mongo_dir/data/db && mkdir -p $mongo_dir/log && touch $mongo_dir/log/mongodb.log",
    before => Exec["launch mongo"],
    require => Exec["install mongo"]
  }

}

include mongo_db_manual_install