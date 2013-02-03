# encoding: utf-8
# CVE-2013-0156
# https://groups.google.com/group/rubyonrails-security/browse_thread/thread/eb56e482f9d21934
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML)
