"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = require("fs");
const yaml = require("js-yaml");
const path_1 = require("path");
const ENV = process.env.NODE_ENV;
const YAML_CONFIG_FILENAME = !ENV ? 'config.yml' : `${ENV}.config.yml`;
const YAML_CONFIG_PATH = path_1.join(__dirname, YAML_CONFIG_FILENAME);
exports.default = () => {
    return yaml.load(fs_1.readFileSync(YAML_CONFIG_PATH, 'utf8'));
};
//# sourceMappingURL=configuration.js.map