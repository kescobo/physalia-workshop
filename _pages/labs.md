---
layout: default
title: Labs
permalink: /labs/
---

All lab activities that are part of the course will be posted to this page:

{% assign labs = site.pages | where_exp: "item" , "item.path contains 'lab_'"%}
{% for lab in labs %}
{% if lab.remote_url %}
- [{{ lab.title }}]({{ lab.remote_url }})
{% else %}
- [{{ lab.title }}]({{ lab.url | prepend: site.baseurl }})
{% endif %}
{% endfor %}