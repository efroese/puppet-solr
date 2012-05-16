# = Class: solr::tomcat
#
# Install solr as a webapp in a tomcat container.
#
# == Parameters:
#
# $solr_xml::   See solr::common
#
# $solrconfig_xml::   See solr::common
#
# $master_url::   See solr::common
#
# $tomcat_home::  Path tot he tomcat install
#
# $tomcat_user::  The user tomcat runs as.
#
# $tomcat_group::  The group tomcat runs as.
#
# $webapp_url::   The url where the solr webapp is (optional)
#
# $solr_context_template:: A template used to render the tomcat context xml file (optional)
#
# == Actions:
#   Install a solr server.
#
# == Sample Usage:
# 
#   class { 'solr::tomcat':
#     tomcat_home  => '/usr/local/tomcat',
#     tomcat_user  => 'tomcat',
#     tomcat_group => 'tomcat',
#   }
#
class solr::tomcat (
    $user              = 'root',
    $group             = 'root',
    $solr_xml          = 'solr/solr.xml.erb',
    $solrconfig_xml    = 'solr/solrconfig.xml.erb',
    $master_url        = 'set the master url',
	$tomcat_home,
    $tomcat_user,
    $tomcat_group,
    $webapp_url            = 'http://dl.dropbox.com/u/24606888/puppet-oae-files/apache-solr-4.0-SNAPSHOT.war',
    $solr_context_template = 'solr/solr-context.xml.erb'){

    # Make sure tomcat6 is executed BEFORE solr::tomcat
    Class['Tomcat6'] -> Class['solr::tomcat']
    # Make sure solr::common is executed BEFORE solr::tomcat
    Class['solr::common'] -> Class['solr::tomcat']

    # Do the heavy lifting
    class { 'solr::common':
       user       => $user,
       group      => $group,
       solr_xml => $solr_xml,
       solrconfig_xml => $solrconfig_xml,
       master_url => $master_url,
    }

    # Get thr solr war
    exec { 'download-war':
        command => "curl -o ${solr::params::share}/solr.war ${webapp_url}",
        creates => "${solr::params::share}/solr.war",
    }

    # Write out the webapp context file to tell tomcat about solr.
    file { "${tomcat_home}/conf/Catalina/localhost/solr.xml":
        owner => $tomcat_user,
        group => $tomcat_group,
        mode  => 0644,
        content => template($solr_context_template),
        require => Exec['download-war'],
    }
}