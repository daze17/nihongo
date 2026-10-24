import base from '@repo/eslint-config';

export default [
  ...base,
  {
    rules: {
      // Nest DI reads constructor parameter types at runtime; type-only imports would erase them.
      '@typescript-eslint/consistent-type-imports': 'off',
      // Nest modules are often empty decorated classes.
      '@typescript-eslint/no-extraneous-class': 'off',
    },
  },
];
