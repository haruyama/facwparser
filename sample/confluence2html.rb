#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
require 'facwparser'

print <<EOS
<!DOCTYPE html>
<html>
<head>
<title>sample</title>
</head>
<body>
EOS
Facwparser.to_html(ARGF.read)
print <<EOS
</body>
</html>
EOS
