# = Class: solr::common
#
# This is where we do most of the heavy lifting.
#
# == Parameters:
#
# $user:: The user that will own solr files
# 
# $group:: The group solr will own solr files
#
# $solr_xml::   A template to render the initial solr.xml file.
#
# $solrconfig_xml::   A template to render the solrconfig.xml file.
#
# $master_url::   The master url for solr clustering (necessary for slave configurations)
#
# == Actions:
#   Install a solr home directory and configuration files.
#
# == Sample Usage:
# 
#   You shouldn't use this class directly. Use solr::jetty or solr::tomcat
#
class solr::common (
    $user              = 'root',
    $group             = 'root',
    $solr_xml          = 'solr/solr.xml.erb',
    $solrconfig_xml    = 'solr/solrconfig.xml.erb',
    $master_url        = 'set the master url') {

    class { 'solr::params': }
    
    Class['Solr::Params'] -> Class['Solr::Common']

    # solr is going to rewrite ${solr::params::conf}/solr.xml
    exec { 'copy-to-solr.xml':
        command => "cp ${solr::params::conf}/solr.xml-stock ${solr::params::conf}/solr.xml",
        creates => "${solr::params::conf}/solr.xml",
        require => File["${solr::params::conf}/solr.xml"],
    }

    file { [
        $solr::params::etc,
        $solr::params::share,
        $solr::params::var,]:
        ensure => directory,
    }
    
    file { [$solr::params::conf, $solr::params::conftemplate,]:
        ensure => directory,
    }

    file { $solr::params::data:
        ensure => directory,
        owner => $user,
        group => $group,
        mode => 755,
        require => File[$solr::params::var]
    }

    file { "${solr::params::conftemplate}/solrconfig.xml":
        owner => $user,
        group => $group,
        mode  => 0644,
        content => template($solrconfig_xml),
        require => File[$solr::params::conftemplate],
    }

    file { "${solr::params::conf}/solr.xml":
        owner => $user,
        group => $group,
        mode  => 0644,
        content => template($solr_xml),
        require => File["$solr::params::conf"],
    }

    # Core managemnent scripts
    file {
        '/usr/sbin/solr-core-create':
            content => template('solr/solr-core-create.erb'),
            owner => root,
            group => root,
            mode => 0755;
        '/usr/sbin/solr-core-unload':
            content => template('solr/solr-core-unload.erb'),
            owner => root,
            group => root,
            mode => 0755;
        '/usr/sbin/solr-core-exists':
            content => template('solr/solr-core-exists.erb'),
            owner => root,
            group => root,
            mode => 0755;
    }
}
