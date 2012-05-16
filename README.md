A puppet module for setting up solr servers.

This module can solr install servers running jetty or tomcat.
It originated life as part of the puppet-oae module https://github.com/efroese/puppet-oae

It requires https://github.com/camptocamp/puppet-archive
If you want to use tomcat you can install tomcat with https://github.com/efroese/puppet-tomcat6

= Example

    class { 'tomcat6': }

    class { 'solr::tomcat':
        tomcat_home => $tomcat6::basedir,
        require => Class['Tomcat6'],
    }

    solr::core::sharedfile {
        'schema.xml':
            source => "/usr/local/deploy/solr/schema.xml";
        'header.txt':
            source => "/usr/local/deploy/solr/header.text";
        'protwords.txt':
            source => "/usr/local/deploy/solr/protwords.text";
        'stopwords.txt':
            source => "/usr/local/deploy/solr/stopwords.text";
        'synonyms.txt':
            source => "/usr/local/deploy/solr/synonyms.text";
    }

    solr::core { [ 'core0', 'core1', ]:
        require => [
            Class['Solr::Tomcat'],
            Solr::Core::Sharedfile['schema.xml'],
            Solr::Core::Sharedfile['stopwords.txt'],
            Solr::Core::Sharedfile['protwords.txt'],
        ]
    }
    
You'll see the following files:
    
    # Core management scripts
    /usr/sbin/solr-core-create $name
    /usr/sbin/solr-core-exists $name
    /usr/sbin/solr-core-unload $name [$delete_indexes=true|false]

    # Shared solr config
    /etc/solr/conf
    /etc/solr/conf/solr.xml

    # New core config templates
    /etc/solr/conftemplate
    
    # Note <dataDir>/var/lib/solr/data/CORENAME</dataDir>
    # CORENAME will be replaced by /usr/sbin/solr-new-core
    /etc/solr/conftemplate/solrconfig.xml

    /etc/solr/conftemplate/header.txt
    /etc/solr/conftemplate/protwords.txt
    /etc/solr/conftemplate/stopwords.txt
    /etc/solr/conftemplate/header.txt
    
    /etc/solr/conf/core0
    /etc/solr/conf/core0/solrconfig.xml
    /etc/solr/conf/core0/header.txt
    /etc/solr/conf/core0/protwords.txt
    /etc/solr/conf/core0/stopwords.txt
    /etc/solr/conf/core0/header.txt
    /var/lib/solr/data/core0

    /etc/solr/conf/core1
    /etc/solr/conf/core1/solrconfig.xml
    /etc/solr/conf/core1/header.txt
    /etc/solr/conf/core1/protwords.txt
    /etc/solr/conf/core1/stopwords.txt
    /etc/solr/conf/core1/header.txt
    /var/lib/solr/data/core1
