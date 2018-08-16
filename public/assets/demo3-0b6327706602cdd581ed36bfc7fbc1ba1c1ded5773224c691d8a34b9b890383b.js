(function() {
  var LineChart,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  LineChart = (function(superClass) {
    extend(LineChart, superClass);

    function LineChart() {
      return LineChart.__super__.constructor.apply(this, arguments);
    }

    LineChart.prototype.prepare_data = function() {
      var e, s;
      s = window.startmonth - 1;
      e = window.endmonth - 1;
      this.data0 = window.map_data.now.slice(s, +e + 1 || 9e9);
      this.data1 = window.map_data.forecast.slice(s, +e + 1 || 9e9);
      return this.data2 = window.map_data.history.slice(s, +e + 1 || 9e9);
    };

    LineChart.prototype.draw = function() {
      var _bar_domain, _xscale_domain, _yscale_domain, bar_width;
      this.prepare_data();
      this.svg = this.draw_svg();
      this.make_defs();
      this.h = this.height - 70;
      this.w = this.width - 200;
      this.gap = (this.w - 30) / 5;
      this.c1 = '#00ff18';
      this.c2 = '#21ed00';
      this.c3 = '#ffad00';
      _bar_domain = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
      _xscale_domain = [0, 11];
      _yscale_domain = [0, 10];
      this.barscale = d3.scaleBand().domain(_bar_domain).range([0, this.w]).paddingInner(0.5).paddingOuter(0);
      bar_width = this.barscale.bandwidth();
      this.xscale = d3.scaleLinear().domain(_xscale_domain).range([bar_width / 2, this.w - bar_width / 2]);
      this.yscale = d3.scaleLinear().domain(_yscale_domain).range([this.h, 0]);
      this.draw_axis();
      this.draw_lines();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          _this.prepare_data();
          return _this.draw_lines();
        };
      })(this));
    };

    LineChart.prototype.make_def = function(r, g, b, id) {
      var lg;
      lg = this.svg_defs.append('linearGradient').attr('id', id).attr('x1', '0%').attr('y1', '0%').attr('x2', '10%').attr('y2', '100%');
      lg.append('stop').attr('offset', '0%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.9)");
      lg.append('stop').attr('offset', '50%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.2)");
      return lg.append('stop').attr('offset', '100%').attr('stop-color', "rgba(" + r + ", " + g + ", " + b + ", 0.0)");
    };

    LineChart.prototype.make_defs = function() {
      this.svg_defs = this.svg.append('defs');
      this.make_def(0, 255, 24, 'line-chart-linear1');
      this.make_def(33, 237, 0, 'line-chart-linear2');
      return this.make_def(255, 173, 0, 'line-chart-linear3');
    };

    LineChart.prototype.draw_lines = function() {
      var _draw, create_line, line1;
      if (this.panel != null) {
        this.panel.remove();
      }
      this.panel = this.svg.append('g').attr('transform', "translate(160, 20)");
      create_line = (function(_this) {
        return function(data) {
          return d3.line().x(function(d, idx) {
            if (idx === 0) {
              return _this.xscale(data.length - 1);
            } else if (idx === 1) {
              return _this.xscale(0);
            } else {
              return _this.xscale(idx - 2);
            }
          }).y(function(d, idx) {
            return _this.yscale(d);
          });
        };
      })(this);
      this.panel.selectAll('path.pre-line').remove();
      this.panel.selectAll('circle').remove();
      line1 = d3.line().x((function(_this) {
        return function(d, idx) {
          return _this.xscale(idx);
        };
      })(this)).y((function(_this) {
        return function(d) {
          return _this.yscale(d);
        };
      })(this)).curve(d3.curveCatmullRom.alpha(0.5));
      _draw = (function(_this) {
        return function(data, color, fill, dasharray) {
          var _data, area, arealine, curve;
          _data = data;
          arealine = create_line(_data);
          area = _this.panel.append('path').datum([0, 0].concat(_data)).attr('class', 'pre-line').attr('d', arealine).style('fill', fill);
          curve = _this.panel.append('path').datum(_data).attr('class', 'pre-line').attr('d', line1).style('stroke', color).style('fill', 'transparent').style('stroke-width', 2).style('stroke-dasharray', dasharray).style('stroke-linecap', 'round');
          return _data.forEach(function(d, idx) {
            var c;
            c = _this.panel.append('circle').attr('cx', _this.xscale(idx)).attr('cy', _this.yscale(d)).attr('r', 3).attr('fill', color);
            return c.transition().duration(1000).attr('cy', _this.yscale(data[idx]));
          });
        };
      })(this);
      _draw(this.data1, this.c2, "url(#line-chart-linear2)", '1 4');
      _draw(this.data2, this.c3, "url(#line-chart-linear3)");
      return this.draw_bars();
    };

    LineChart.prototype.draw_bars = function() {
      var bar_width;
      bar_width = this.barscale.bandwidth();
      return this.panel.selectAll('.amount-bar').data(this.data0).enter().append('rect').attr('class', 'amount-bar').attr('width', bar_width).attr('fill', '#6a94dc').attr('height', (function(_this) {
        return function(d) {
          return _this.h - _this.yscale(d);
        };
      })(this)).attr('transform', (function(_this) {
        return function(d, idx) {
          return "translate(" + (_this.barscale(idx)) + ", " + (_this.yscale(d)) + ")";
        };
      })(this)).style('opacity', '0.7');
    };

    LineChart.prototype.draw_axis = function() {
      var axisx, axisy, offx, offy;
      offx = 160;
      offy = 20;
      axisx = this.svg.append('g').attr('class', 'axis axis-x white').attr('transform', "translate(" + offx + ", " + (offy + this.h) + ")");
      axisy = this.svg.append('g').attr('class', 'axis axis-y white').attr('transform', "translate(" + offx + ", " + offy + ")");
      axisx.call(d3.axisBottom(this.barscale).tickValues([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]).tickFormat(function(d, idx) {
        var arr;
        arr = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十', '十一', '十二'];
        return arr[idx] + "月";
      }));
      return axisy.call(d3.axisLeft(this.yscale).tickValues([0, 2, 4, 6, 8, 10]).tickFormat(function(d, idx) {
        if (d === 0) {
          return '0';
        }
        return d + "000 万";
      })).selectAll('.tick line').attr('x1', this.w);
    };

    return LineChart;

  })(Graph);

  BaseTile.register('line-chart', LineChart);

}).call(this);
(function() {
  var LineChartTitle,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  LineChartTitle = (function(superClass) {
    extend(LineChartTitle, superClass);

    function LineChartTitle() {
      return LineChartTitle.__super__.constructor.apply(this, arguments);
    }

    LineChartTitle.prototype.prepare_data = function() {
      this.total_data = window.map_data.total;
      return this.export_data = window.map_data["export"];
    };

    LineChartTitle.prototype.draw = function() {
      this.prepare_data();
      this.svg = this.draw_svg();
      this.c1 = '#6a94dc';
      this.c2 = '#21ed00';
      this.c3 = '#ffad00';
      this.number_color = '#fcf926';
      this.draw_texts();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          _this.prepare_data();
          return _this.draw_texts();
        };
      })(this));
    };

    LineChartTitle.prototype.draw_texts = function() {
      var left, scale, size, t1, t2, texts, topoff;
      if (this.texts != null) {
        this.texts.remove();
      }
      texts = this.texts = this.svg.append('g').style('transform', 'translate(1100px, 0px)');
      scale = 1;
      left = 200;
      if (jQuery('.paper.large')[0]) {
        scale = 2;
        left = 1600;
      }
      size = 40 * scale;
      texts.append('text').attr('x', -1050).attr('y', this.height / 2).attr('dy', '.33em').text('产品总体销量').style('font-size', size + "px").style('fill', '#ffffff');
      this.total_text = t1 = texts.append('text').attr('x', -1050 + 270 * scale).attr('y', this.height / 2).attr('dy', '.33em').text(this.total_data).style('font-size', (size * 1.5) + "px").style('fill', this.number_color);
      texts.append('text').attr('x', -1050 + 600 * scale).attr('y', this.height / 2).attr('dy', '.33em').text('产品出口销量').style('font-size', size + "px").style('fill', '#ffffff');
      this.out_text = t2 = texts.append('text').attr('x', -1050 + (600 + 270) * scale).attr('y', this.height / 2).attr('dy', '.33em').text(this.export_data).style('font-size', (size * 1.5) + "px").style('fill', this.number_color);
      size = 20 * scale;
      topoff = 16 * scale;
      texts.append('rect').attr('x', left).attr('y', this.height / 2 - 8 * scale + topoff).attr('width', 25 * scale).attr('height', 15 * scale).style('fill', this.c1);
      texts.append('text').attr('x', left + 40 * scale).attr('y', this.height / 2 + topoff).attr('dy', '.33em').text('实际销量').style('font-size', size + "px").style('fill', '#ffffff');
      texts.append('rect').attr('x', left + 140 * scale).attr('y', this.height / 2 - 8 * scale + topoff).attr('width', 25 * scale).attr('height', 15 * scale).style('fill', this.c2);
      texts.append('text').attr('x', left + 180 * scale).attr('y', this.height / 2 + topoff).attr('dy', '.33em').text('预测销量').style('font-size', size + "px").style('fill', '#ffffff');
      texts.append('rect').attr('x', left + 280 * scale).attr('y', this.height / 2 - 8 * scale + topoff).attr('width', 25 * scale).attr('height', 15 * scale).style('fill', this.c3);
      return texts.append('text').attr('x', left + 320 * scale).attr('y', this.height / 2 + topoff).attr('dy', '.33em').text('去年同比销量').style('font-size', size + "px").style('fill', '#ffffff');
    };

    return LineChartTitle;

  })(Graph);

  BaseTile.register('line-chart-title', LineChartTitle);

}).call(this);
(function() {
  var CityAnimate, LOGO_PATH, MainMap, codes, rand_item_of,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  LOGO_PATH = "M461.331,294.545c-11.119-34.221-56.452-50.278-102.081-36.623c-1.106-47.624-30.406-85.779-66.393-85.779c-35.987,0-65.286,38.155-66.393,85.779c-45.629-13.655-90.961,2.403-102.08,36.624c-11.12,34.226,16.114,73.882,61.065,89.65c-27.087,39.176-25.823,87.252,3.286,108.401c29.114,21.152,75.234,7.491,104.123-30.387c28.888,37.878,75.008,51.538,104.122,30.387c29.11-21.149,30.373-69.226,3.286-108.402C445.218,368.426,472.45,328.771,461.331,294.545z";

  codes = {
    yazhou: ["AFG", "ARE", "ARM", "AZE", "BGD", "BRN", "BTN", "CHN", "-99", "GEO", "YEM", "IDN", "IND", "IRN", "IRQ", "ISR", "JOR", "JPN", "KAZ", "KGZ", "KHM", "KOR", "KWT", "LAO", "LBN", "LKA", "MMR", "MNG", "MYS", "NPL", "OMN", "PAK", "PHL", "PRK", "QAT", "SAU", "SYR", "THA", "TJK", "TKM", "TLS", "TUR", "UZB", "VNM", "PSE"],
    feizhou: ["AGO", "BDI", "BEN", "BFA", "BWA", "CAF", "CIV", "CMR", "COD", "COG", "DJI", "DZA", "EGY", "ERI", "ZWE", "ETH", "GAB", "GHA", "GIN", "GMB", "GNB", "GNQ", "ZAF", "ZMB", "KEN", "LBR", "LBY", "LSO", "MAR", "MDG", "MLI", "MOZ", "MRT", "MWI", "NAM", "NER", "NGA", "RWA", "-99", "SDN", "SDS", "SEN", "SLE", "-99", "SOM", "SWZ", "TCD", "TGO", "TUN", "TZA", "UGA"],
    ouzhou: ["ALB", "AUT", "BEL", "BGR", "BIH", "BLR", "CHE", "CYP", "CZE", "DEU", "DNK", "ESP", "EST", "FIN", "FRA", "GBR", "GRC", "HRV", "HUN", "IRL", "ISL", "ITA", "-99", "LTU", "LUX", "LVA", "MDA", "MKD", "MNE", "NLD", "NOR", "POL", "PRT", "ROU", "RUS", "SRB", "SVK", "SVN", "SWE", "UKR"],
    nanmei: ["ARG", "BOL", "BRA", "CHL", "COL", "CUB", "ECU", "FLK", "GUY", "PAN", "PER", "PRY", "SUR", "URY", "VEN"],
    nanji: ["ATA", "ATF"],
    aozhou: ["AUS", "FJI", "NCL", "NZL", "PNG", "SLB", "VUT"],
    beimei: ["BHS", "BLZ", "CAN", "CRI", "DOM", "GRL", "GTM", "HND", "HTI", "JAM", "MEX", "NIC", "PRI", "SLV", "TTO", "USA"]
  };

  rand_item_of = function(arr) {
    return arr[Math.floor(arr.length * Math.random())];
  };

  MainMap = (function(superClass) {
    extend(MainMap, superClass);

    function MainMap() {
      return MainMap.__super__.constructor.apply(this, arguments);
    }

    MainMap.prototype.prepare_data = function() {
      this.cn_cities = window.map_data.cn_cities;
      this.world_cities = window.map_data.world_cities;
      this.max_number = 0;
      return this.cn_cities.forEach((function(_this) {
        return function(x) {
          return _this.max_number = Math.max(x.amount, _this.max_number);
        };
      })(this));
    };

    MainMap.prototype.draw = function() {
      this.prepare_data();
      this.MAP_STROKE_COLOR = '#c8d8f1';
      this.MAP_FILL_COLOR = '#323c48';
      this.svg = this.draw_svg();
      this.load_data();
      return jQuery(document).on('data-map:next-draw', (function(_this) {
        return function() {
          _this.prepare_data();
          return _this.next_draw();
        };
      })(this));
    };

    MainMap.prototype.next_draw = function() {
      if (this.iidx == null) {
        this.iidx = 0;
      }
      this.iidx += 1;
      if (this.iidx % 4 === 0) {
        return this.random_city();
      }
    };

    MainMap.prototype.load_data = function() {
      return d3.json('data/world-countries.json?1', (function(_this) {
        return function(error, _data) {
          return d3.json('data/china.json?1', function(error, _data_c) {
            _this.features = _data.features;
            _this.features_c = _data_c.features;
            _this.draw_map();
            return _this.random_city();
          });
        };
      })(this));
    };

    MainMap.prototype.draw_map = function() {
      this.map_scale = [0.125];
      this.projection = d3.geoProjection((function(_this) {
        return function(x, y) {
          return d3.geoEquirectangularRaw(x * 1.17, y);
        };
      })(this)).center([0, 16]).scale(this.width * this.map_scale).translate([this.width / 2, this.height / 2]);
      this.path = d3.geoPath(this.projection);
      this.g_map = this.svg.append('g');
      this.make_def();
      this._draw_shadow();
      return this._draw_map();
    };

    MainMap.prototype.make_def = function() {
      var lg;
      this.svg_defs = this.svg.append('defs');
      lg = this.svg_defs.append('filter').attr('id', 'g_blur');
      return lg.append('feGaussianBlur').attr('in', 'SourceGraphic').attr('stdDeviation', 3);
    };

    MainMap.prototype._draw_shadow = function() {
      var countries;
      this.g_map.selectAll('.country-shadow').remove();
      return countries = this.g_map.selectAll('.country-shadow').data(this.features).enter().append('path').attr('class', 'country-shadow').attr('d', this.path).style('transform', 'translate(5px, 5px)').style('stroke-width', 0).style('filter', 'url(#g_blur)').style('fill', (function(_this) {
        return function(d, idx) {
          return '#000000';
        };
      })(this));
    };

    MainMap.prototype._draw_map = function() {
      var countries;
      this.g_map.selectAll('.country').remove();
      countries = this.g_map.selectAll('.country').data(this.features).enter().append('path').attr('class', 'country').attr('d', this.path).style('stroke', this.MAP_STROKE_COLOR).style('stroke-width', 1).style('fill', (function(_this) {
        return function(d, idx) {
          if (d.id === 'CHN') {
            return '#ffae00';
          }
          if (['CAN', 'SAU', 'PRT', 'CZE', 'AUT', 'HUN', 'SRB', 'MDA', 'EST', 'TKM', 'BGD', 'KHM', 'TKM'].indexOf(d.id) > -1) {
            return '#273957';
          }
          if (['ESP', 'MEX', 'BRA', 'ARG', 'GUY', 'ITA', 'CHE', 'SWE', 'TUR', 'ROU', 'KAZ', 'UZB', 'LAO', 'MYS'].indexOf(d.id) > -1) {
            return '#21437d';
          }
          if (['FRA', 'RUS', 'USA', 'PAK', 'NOR', 'FIN', 'POL', 'UKR', 'LTU', 'IDN', 'NLD'].indexOf(d.id) > -1) {
            return '#3a62a6';
          }
          if (['DEU', 'IND', 'GBR', 'IRN', 'AUS', 'THA', 'MMR', 'VNM', 'PHL', 'NZL'].indexOf(d.id) > -1) {
            return '#6a95dd';
          }
          if (['JPN', 'KOR'].indexOf(d.id) > -1) {
            return '#3c85ff';
          }
          return '#a0bbe8';
        };
      })(this));
      return this.g_map.selectAll('.country-c').data(this.features_c).enter().append('path').attr('class', 'country-c').attr('d', this.path).style('stroke-width', 0).style('fill', (function(_this) {
        return function(d, idx) {
          if (d.properties.id === '52') {
            return '#ff4800';
          }
          return 'transparent';
        };
      })(this));
    };

    MainMap.prototype.draw_heatmap = function() {
      var cities, data, heatmapInstance, points;
      return false;
      heatmapInstance = h337.create({
        container: jQuery('#heatmap')[0],
        radius: 16,
        gradient: {
          '0.0': '#ffffff',
          '0.3': '#ffffff',
          '1.0': '#ffffff'
        }
      });
      cities = [].concat(this.cn_cities).concat(this.world_cities);
      points = cities.map((function(_this) {
        return function(c) {
          var ref, x, y;
          ref = _this.projection([c.long, c.lat]), x = ref[0], y = ref[1];
          return {
            x: ~~x,
            y: ~~y,
            value: c.amount
          };
        };
      })(this));
      data = {
        max: this.max_number,
        data: points
      };
      return heatmapInstance.setData(data);
    };

    MainMap.prototype.random_city = function() {
      if (this.svg1 != null) {
        this.svg1.remove();
      }
      this.svg1 = this.draw_svg().style('position', 'absolute').style('left', '0').style('top', '0');
      return this._r(this.world_cities, '#fcdc70', false);
    };

    MainMap.prototype._r = function(arr, color, is_china) {
      var p, ref, x, y;
      p = rand_item_of(arr);
      ref = this.projection([p.long, p.lat]), x = ref[0], y = ref[1];
      return new CityAnimate(this, x, y, color, 8, is_china).run();
    };

    return MainMap;

  })(Graph);

  CityAnimate = (function() {
    function CityAnimate(map, x2, y2, color1, width, is_china1) {
      this.map = map;
      this.x = x2;
      this.y = y2;
      this.color = color1;
      this.width = width;
      this.is_china = is_china1;
      this.g_map = this.map.svg1;
    }

    CityAnimate.prototype.run = function() {
      return this.flight_animate();
    };

    CityAnimate.prototype.flight_animate = function() {
      var ref;
      ref = this.map.projection([106.4, 26.3]), this.gyx = ref[0], this.gyy = ref[1];
      this.draw_plane();
      this.draw_route();
      return this.fly();
    };

    CityAnimate.prototype.draw_plane = function() {};

    CityAnimate.prototype.draw_route = function() {
      var alpha, dx, dy, p, p0, p1, s0, s1, x1, xmid, y1, ymid;
      xmid = (this.gyx + this.x) / 2;
      ymid = (this.gyy + this.y) / 2;
      dx = this.gyx - this.x;
      dy = this.gyy - this.y;
      s0 = Math.sqrt(dx * dx + dy * dy);
      s1 = s0 / 4;
      alpha = Math.asin(dy / s0);
      p0 = this.x > this.gyx ? 1 : -1;
      p1 = this.y > this.gyy ? -1 : 1;
      p = p0 * p1;
      x1 = xmid - Math.abs(s1 * Math.sin(alpha)) * p;
      y1 = ymid - Math.abs(s1 * Math.cos(alpha));
      return this.route = this.g_map.append('path').attr('d', "M" + this.gyx + " " + this.gyy + " Q" + x1 + " " + y1 + " " + this.x + " " + this.y).style('stroke', 'rgba(255, 255, 255, 0.1)').style('fill', 'transparent');
    };

    CityAnimate.prototype.fly = function() {
      var center_xoff, center_yoff, count, dx, dy, l, last_len, path, scale, xoff, yoff;
      path = this.route.node();
      l = path.getTotalLength();
      dx = this.x - this.gyx;
      dy = this.y - this.gyy;
      center_xoff = 586;
      center_yoff = 696;
      scale = 0.08;
      xoff = center_xoff * scale * 0.5;
      yoff = center_yoff * scale * 0.5;
      count = 0;
      last_len = 0;
      return jQuery({
        t: 0
      }).animate({
        t: 1
      }, {
        step: (function(_this) {
          return function(now, fx) {
            var len, p;
            len = now * l;
            p = path.getPointAtLength(len);
            if (len - last_len > 6) {
              _this.route_circle_wave(p.x, p.y);
              return last_len = len;
            }
          };
        })(this),
        duration: Math.sqrt(l) * 150,
        easing: 'linear',
        done: (function(_this) {
          return function() {
            return _this.route.remove();
          };
        })(this)
      });
    };

    CityAnimate.prototype.route_circle_wave = function(x, y) {
      var circle;
      circle = this.g_map.insert('circle', '.plane').attr('cx', x).attr('cy', y).attr('stroke', this.color).attr('stroke-width', 0).attr('fill', this.color);
      return jQuery({
        r: 8,
        o: 0.9
      }).delay(100).animate({
        r: 4,
        o: 0
      }, {
        step: function(now, fx) {
          if (fx.prop === 'r') {
            circle.attr('r', now);
          }
          if (fx.prop === 'o') {
            return circle.style('opacity', now);
          }
        },
        duration: 1500,
        easing: 'easeOutQuad',
        done: (function(_this) {
          return function() {
            return circle.remove();
          };
        })(this)
      });
    };

    CityAnimate.prototype.three_paths_wave = function() {
      this.path_wave(0);
      this.path_wave(500);
      return this.path_wave(1000);
    };

    CityAnimate.prototype.path_wave = function(delay) {
      var center_xoff, center_yoff, path, scale, x, y;
      center_xoff = 586;
      center_yoff = 696;
      scale = 0.1;
      x = this.x - center_xoff * scale * 0.5;
      y = this.y - center_yoff * scale * 0.5;
      path = this.g_map.append('path').attr('d', LOGO_PATH).attr('stroke', this.color).attr('stroke-width', 20).attr('fill', 'transparent').attr('transform', "translate(" + x + ", " + y + ") scale(" + scale + ")");
      return jQuery({
        scale: 0.1,
        o: 1
      }).delay(delay).animate({
        scale: 0.2,
        o: 0
      }, {
        step: (function(_this) {
          return function(now, fx) {
            if (fx.prop === 'scale') {
              scale = now;
              x = _this.x - center_xoff * scale * 0.5;
              y = _this.y - center_yoff * scale * 0.5;
              path.attr('transform', "translate(" + x + ", " + y + ") scale(" + scale + ")");
            }
            if (fx.prop === 'o') {
              return path.style('opacity', now);
            }
          };
        })(this),
        duration: 2000,
        easing: 'easeOutQuad',
        done: function() {
          return path.remove();
        }
      });
    };

    return CityAnimate;

  })();

  BaseTile.register('main-map', MainMap);

}).call(this);

window.data_path = '/demo3/data'
;
