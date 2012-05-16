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
            exec { "solr-core-create-$":
                command => "/usr/sbin/solr-core-new ${name}",
                unless  => "/usr/sbin/solr-core-exists ${name}",
            }
        }

        unload : {
            exec { "solr-core-unload-$":
                command => "/usr/sbin/solr-core-unload ${name} ${delete_indexes}",
                onlyif  => "/usr/sbin/solr-core-exists ${name}",
            }
        }

        default : {
            fail("Unknown ensure value ${ensure}. Valid values are present and unload")
        }
    }   
}