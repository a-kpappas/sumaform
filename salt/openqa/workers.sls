{% for i in ranges(grains['workers']) %}
openqa-worker@i:
  service.running:
    - enable: True
    require:
      - sls: bootstrap
{% endfor %}
