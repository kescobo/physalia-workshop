---
layout: default
title: Labs
permalink: /labs/
---

All lab activities that are part of the course will be posted to this page:

{% assign labs = site.pages | where_exp: "item" , "item.path contains 'lab_'"%}
{% for lab in labs %}
- [{{ lab.title }}]({{ lab.url }})
{% endfor %}