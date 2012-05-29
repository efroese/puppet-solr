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

    # Download the source tarball
    # /usr/local/solr/solr-source
    archive { 'solr-source':
        ensure         => present,
        url            => 'http://nodeload.github.com/sakaiproject/solr/tarball/org.sakaiproject.nakamura.solr-1.3-20120215',
        checksum       => false,
        target         => $localconfig::basedir,
        src_target     => $localconfig::basedir,
        allow_insecure => true,
        timeout        => '0',
        notify         => Exec['mv-solr-source'],
    }

    # The expanded folder name will be ${organization}-${repository}-${revision}
    exec { 'mv-solr-source':
        command => "mv ${localconfig::basedir}/`tar tf ${localconfig::basedir}/solr-source.tar.gz 2>/dev/null | head -1` ${localconfig::basedir}/solr-source",
        refreshonly => true,
    }

    solr::core::sharedfile {
        'schema.xml':
            source => "file://${localconfig::basedir}/solr-source/src/main/resources/schema.xml";
        'protwords.txt':
            source => "file://${localconfig::basedir}/solr-source/src/main/resources/protwords.txt";
        'stopwords.txt':
            source => "file://${localconfig::basedir}/solr-source/src/main/resources/stopwords.txt";
        'synonyms.txt':
            source => "file://${localconfig::basedir}/solr-source/src/main/resources/synonyms.txt";
    }

    solr::core { [ 'core0', 'core1', ]:
        #ensure => unload,
        #delete_indexes => true,
        require => [
            Class['Solr::Tomcat'],
            Solr::Core::Sharedfile['schema.xml'],
            Solr::Core::Sharedfile['protwords.txt'],
            Solr::Core::Sharedfile['stopwords.txt'],
            Solr::Core::Sharedfile['synonyms.txt'],
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
