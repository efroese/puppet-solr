# = Class: solr::tomcat
#
# Install solr as a webapp in a tomcat container.
#
# == Parameters:
#
# $basedir:: See solr::common
#
# $solr_tarball:: See solr::common
#
# $solr_home_tarball:: See solr::common
#
# $solrconfig::   See solr::common
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
#     solr_tarball => "http://source.sakaiproject.org/release/oae/solr/solr-example.tar.gz",
#     solrconfig   => 'localconfig/solrconfig.xml.erb',
#     schema       => 'localconfig/schema.xml.erb',
#     tomcat_home  => '/usr/local/tomcat',
#     tomcat_user  => 'tomcat',
#     tomcat_group => 'tomcat',
#   }
#
class solr::tomcat (
    $basedir           = '/usr/local/solr',
    $user              = 'root',
    $group             = 'root',
    $solr_tarball      = "http://nodeload.github.com/sakaiproject/solr/tarball/master",
    $solr_home_tarball = "http://dl.dropbox.com/u/24606888/puppet-oae-files/home0.tgz",
    $solrconfig        = 'solr/solrconfig.xml.erb',
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
       basedir           => $basedir,
       user              => $user,
       group             => $group,
       solr_tarball      => $solr_tarball,
       solr_home_tarball => $solr_home_tarball,
       solrconfig        => $solrconfig,
       master_url        => $master_url,
    }

    # Get thr solr war
    exec { 'download-war':
        command => "curl -o ${solr::common::basedir}/solr.war ${webapp_url}",
        creates => "${solr::common::basedir}/solr.war",
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