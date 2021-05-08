import { readFileSync } from 'fs';
import * as yaml from 'js-yaml';
import { join } from 'path';

const ENV = process.env.NODE_ENV;

const YAML_CONFIG_FILENAME = !ENV ? 'config.yml' : `${ENV}.config.yml`;
const YAML_CONFIG_PATH = join(__dirname, YAML_CONFIG_FILENAME);

export default () => {
  return yaml.load(readFileSync(YAML_CONFIG_PATH, 'utf8'));
};
