#
# = Define: solr::core
#
# Manage a solr core instance using CoreAdmin
# http://wiki.apache.org/solr/CoreAdmin
#
# == Parameters:
#
# $ensure:: present or unload
#
# $delete_indexes:: Delete the index files? DANGEROUS!? Valid only when ensure => unload
#
# == Sample Usage:
#
#   solr::core { 'core0':
#       ensure => present,
#   }
#
#   solr::core { 'decommissioned':
#       ensure => unload,
#   }
#
#   solr::core { 'oldindex':
#       ensure => unload,
#       delete_indexes => true,
#   }
#
define solr::core(
    $ensure = present,
    $delete_indexes = false
    ) {

    case $ensure {

        present : {

            exec { "solr-core-create-${name}":
                command => "/usr/sbin/solr-core-create ${name}",
                unless  => "/usr/sbin/solr-core-exists ${name}",
                require => File["${solr::params::data}'/${name}"],
            }

            file { "${solr::params::data}/${name}":
                ensure => directory,
                owner  => $solr::common::user,
                group  => $solr::common::group,
            }
        }

        unload : {
            exec { "solr-core-unload-${name}":
                command => "/usr/sbin/solr-core-unload ${name} ${delete_indexes}",
                onlyif  => "/usr/sbin/solr-core-exists ${name}",
            }
        }

        default : {
            fail("Unknown ensure value ${ensure}. Valid values are present and unload")
        }
    }   
}