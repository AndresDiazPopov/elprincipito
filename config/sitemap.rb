require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'HOST'
SitemapGenerator::Sitemap.create do
end
SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks