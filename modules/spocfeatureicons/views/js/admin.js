(function () {
  'use strict';

  function getConfig() {
    if (typeof window.spocFeatureIconsField === 'undefined') {
      return null;
    }

    return window.spocFeatureIconsField;
  }

  function findFeatureForm() {
    var selectors = [
      'form[name="feature"]',
      '#feature_form',
      'form[action*="/features"]',
      'form[action*="AdminFeatures"]'
    ];

    for (var i = 0; i < selectors.length; i += 1) {
      var form = document.querySelector(selectors[i]);
      if (form) {
        return form;
      }
    }

    var forms = document.querySelectorAll('form');
    for (var j = 0; j < forms.length; j += 1) {
      if (
        forms[j].querySelector('[name*="[name]"]')
        || forms[j].querySelector('[name^="feature["]')
        || forms[j].querySelector('[name^="name_"]')
      ) {
        return forms[j];
      }
    }

    return null;
  }

  function createElement(tagName, className, text) {
    var element = document.createElement(tagName);

    if (className) {
      element.className = className;
    }

    if (text) {
      element.appendChild(document.createTextNode(text));
    }

    return element;
  }

  function buildField(config) {
    var wrapper = createElement('div', 'form-group row spoc-feature-icon-field spoc-feature-icon-field--injected');
    var label = createElement('label', 'form-control-label control-label col-sm-3 col-lg-3', config.label);
    var control = createElement('div', 'col-sm-9 col-lg-9');

    wrapper.setAttribute('data-spoc-feature-icon-field', '1');

    if (config.currentUrl) {
      var preview = createElement('div', 'spoc-feature-icon-preview');
      var image = document.createElement('img');
      var filename = createElement('span', '', config.currentFilename || '');
      var deleteLabel = createElement('label', 'spoc-feature-icon-delete');
      var deleteInput = document.createElement('input');

      image.src = config.currentUrl;
      image.alt = '';
      image.width = 40;
      image.height = 40;

      deleteInput.type = 'checkbox';
      deleteInput.name = config.deleteName;
      deleteInput.value = '1';

      preview.appendChild(image);
      preview.appendChild(filename);
      deleteLabel.appendChild(deleteInput);
      deleteLabel.appendChild(document.createTextNode(' ' + config.deleteLabel));
      control.appendChild(preview);
      control.appendChild(deleteLabel);
    }

    var input = document.createElement('input');
    input.type = 'file';
    input.name = config.uploadName;
    input.accept = config.accept;
    input.className = 'form-control';

    control.appendChild(input);
    control.appendChild(createElement('p', 'help-block form-text text-muted', config.help));
    wrapper.appendChild(label);
    wrapper.appendChild(control);

    return wrapper;
  }

  function insertField() {
    var config = getConfig();
    var form = config ? findFeatureForm() : null;

    if (!config || !form || form.querySelector('[data-spoc-feature-icon-field], .spoc-feature-icon-field')) {
      return;
    }

    var field = buildField(config);
    var target = form.querySelector('.card-body') || form.querySelector('.panel-body') || form;
    var footer = target.querySelector('.card-footer, .panel-footer, .form-footer, .form-actions');

    form.setAttribute('enctype', 'multipart/form-data');

    if (footer && footer.parentNode === target) {
      target.insertBefore(field, footer);
      return;
    }

    target.appendChild(field);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', insertField);
    return;
  }

  insertField();
})();
