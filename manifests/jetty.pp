# = Class: solr
#
# This class installs a standalone solr master or slave running in the Jetty servlet container.
#
# == Parameters:
#
# $user:: The user solr will run as
#
# $group:: The group solr will run as
#
# $solr_xml::   See solr::common
#
# $solrconfig_xml::   See solr::common
#
# $master_url::   See solr::common
#
# == Actions:
#   Install a solr server.
#
# == Sample Usage:
# 
#   class { 'solr::jetty':
#     solrconfig_xml => 'myconfig/solrconfig.xml.erb',
#     master_url => 'http://solr.server:8080/solr'
#   }
#
class solr::jetty(
    $user              = 'root',
    $group             = 'root',
    $solr_xml          = 'solr/solr.xml.erb',
    $solrconfig_xml    = 'solr/solrconfig.xml.erb',
    $master_url        = 'set the master url' ) {

    # Make sure solr::common is executed BEFORE solr::jetty
    Class['solr::common'] -> Class['solr::jetty']

    # Lift heavy things
    class { 'solr::common':
        user           => $user,
        group          => $group,
        solr_xml       => $solr_xml,
        solrconfig_xml => $solrconfig_xml,
        master_url     => $master_url,
    }

    # Drop the init script
    file { '/etc/init.d/solr':
        ensure => present,
        owner  => $user,
        group  => $group,
        mode   => 0755,
        content => template("solr/solr.erb"),
    }

    # And turn it on
    service { 'solr':
        ensure => running,
        enable => true,
    }
}
