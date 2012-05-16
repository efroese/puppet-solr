class solr::params {

    # Data for each core
    $var = '/var/lib/solr'
    $data = "${var}/data"
    
    # solr config
    $etc = '/etc/solr'
    $conf = "${etc}/conf"
    
    # core config template
    $conftemplate = "${etc}/conftemplate"

    $share = '/usr/share/solr'
}