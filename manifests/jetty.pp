# = Class: solr
#
# This class installs a standalone solr master or slave with jetty.
#
# == Parameters:
#
# $solr_tarball:: See solr::common
#
# $solr_home_tarball:: See solr::common
#
# $solrconfig::   See solr::common
#
# $master_url::   See solr::common
#
# == Actions:
#   Install a solr server.
#
# == Sample Usage:
# 
#   class { 'solr::jetty':
#     solr_tarball => "http://source.sakaiproject.org/release/oae/solr/solr-example.tar.gz",
#     solrconfig   => 'myconfig/solrconfig.xml.erb',
#   }
#
class solr::jetty(
    $user              = 'root',
    $group             = 'root',
    $solr_tarball      = "http://nodeload.github.com/sakaiproject/solr/tarball/master",
    $solr_home_tarball = "http://dl.dropbox.com/u/24606888/puppet-oae-files/home0.tgz",
    $solrconfig        = 'solr/solrconfig.xml.erb',
    $master_url        = 'set the master url' ) {

    Class['solr::common'] -> Class['solr::jetty']

    class { 'solr::common':
        solr_tarball      => $solr_git,
        solr_home_tarball => $solr_home_tarball,
        solrconfig        => $solrconfig,
        master_url        => $master_url,
    }

    file { '/etc/init.d/solr':
        ensure => present,
        owner  => $user,
        group  => $group,
        mode   => 0755,
        content => template("solr/solr.erb"),
    }

    service { 'solr':
        ensure => running,
        enable => true,
        subscribe => File["${solr_conf_dir}/solrconfig.xml"], 
    }
}