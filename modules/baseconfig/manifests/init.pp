class baseconfig {
  class { '::ntp': servers => ['0.ie.pool.ntp.org', '1.ie.pool.ntp.org', '3.ie.pool.ntp.org', '4.ie.pool.ntp.org'], }

  class { 'timezone':
    region   => 'Europe',
    locality => 'Dublin',
  }

}
