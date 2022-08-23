{% for i in ranges(grains['ps.num_cpus']) %}
openqa-worker@i:
  service.running:
    - enable: True
    require:
      - sls: bootstrap
{% endfor %}
