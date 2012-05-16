#
# = Define: solr::core::sharedfile
# A file that will be copied from the conftemplate to new cores
#
# == Parameters
#
# $name:: The file name
#
# $content:: The content of the file (use this OR source)
#
# $source:: The source of the file (use this OR content)
#
define solr::core::sharedconfig(
    $content = '',
    $source  = ''){

    if ($source == '' and $content != '') {
        # /etc/solr/conftemplate/${name}
        file { "${solr::params::conftemplate}/${name}":
            owner => $solr::common::user,
            group => $solr::common::group,
            mode  => 0644,
            content => $content,
        }

        # /etc/solr/conf/${name}
        file { "${solr::params::conf}/${name}":
            owner => $solr::common::user,
            group => $solr::common::group,
            mode  => 0644,
            content => $content,
        }
    }

    if ($source != '' and $content == '') {
        # /etc/solr/conftemplate/${name}
        file { "${solr::params::conftemplate}/${name}":
            owner => $solr::common::user,
            group => $solr::common::group,
            mode  => 0644,
            content => $content,
        }

        # /etc/solr/conf/${name}
        file { "${solr::params::conf}/${name}":
            owner => $solr::common::user,
            group => $solr::common::group,
            mode  => 0644,
            content => $content,
        }
    }

    if ($source == '' and $content == '') {
        fail("Supply content or source, not both.")
    }
}