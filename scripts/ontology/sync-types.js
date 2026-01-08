#!/usr/bin/env node

/**
 * AIRules Ontology - Type Usage Analysis
 *
 * Analyzes TypeScript type definitions and their usage across the project.
 * Creates a comprehensive report of type utilization and dependencies.
 *
 * Features:
 * - Type definition parsing
 * - Usage tracking across project
 * - Import pattern analysis
 * - Cross-platform support
 *
 * Output: docs/TYPES_REPORT.json
 */

const fs = require('fs');
const path = require('path');

/**
 * Find all TypeScript files in directory recursively
 */
function findTypeFiles(dir) {
  const files = [];

  try {
    const items = fs.readdirSync(dir);

    for (const item of items) {
      const fullPath = path.join(dir, item);
      const stat = fs.statSync(fullPath);

      if (stat.isDirectory()) {
        // Skip common exclude directories
        if (!['node_modules', '.next', 'dist', '.git', 'build'].includes(item)) {
          files.push(...findTypeFiles(fullPath));
        }
      } else if (item.endsWith('.ts') && !item.endsWith('.d.ts') && !item.includes('.test.') && !item.includes('.spec.')) {
        files.push(fullPath);
      }
    }
  } catch (err) {
    // Skip files we can't read
  }

  return files;
}

/**
 * Parse type file and extract exported types/interfaces
 */
function parseTypeFile(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const fileName = path.basename(filePath);

    const typeExports = [];

    // Find export type XXX = and export interface XXX
    const typeRegex = /export\s+(type|interface)\s+([A-Z][a-zA-Z0-9_]*)/g;
    let match;
    while ((match = typeRegex.exec(content)) !== null) {
      typeExports.push({
        type: match[1], // 'type' or 'interface'
        name: match[2],
        line: getLineNumber(content, match[0])
      });
    }

    return {
      fileName,
      filePath,
      typeExports
    };
  } catch (err) {
    console.warn(`⚠️ Could not parse type file ${filePath}:`, err.message);
    return null;
  }
}

/**
 * Search for type usage in the entire project
 */
function findTypeUsages(typeName, rootDir) {
  const usages = [];
  const searchExtensions = ['.ts', '.tsx'];

  function searchDir(dir) {
    try {
      const items = fs.readdirSync(dir);

      for (const item of items) {
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
          // Skip excluded directories
          if (!['node_modules', '.next', 'dist', '.git', 'build'].includes(item)) {
            searchDir(fullPath);
          }
        } else {
          const ext = path.extname(item);
          if (searchExtensions.includes(ext)) {
            try {
              const content = fs.readFileSync(fullPath, 'utf8');

              // Search for type imports
              const importRegex = new RegExp(
                `import\\s*\\{[^}]*\\b${typeName}\\b[^}]*\\}\\s*from\\s+['"]([^'"]+)['"]|import\\s+${typeName}\\s+from\\s+['"]([^'"]+)['"]`,
                'g'
              );

              const matches = content.match(importRegex);
              if (matches) {
                usages.push({
                  filePath: path.relative(rootDir, fullPath),
                  importCount: matches.length
                });
              }
            } catch (err) {
              // Skip files we can't read
            }
          }
        }
      }
    } catch (err) {
      // Skip directories we can't access
    }
  }

  searchDir(rootDir);
  return usages;
}

/**
 * Get line number by position in text
 */
function getLineNumber(content, searchStr) {
  const before = content.substring(0, content.indexOf(searchStr));
  return before.split('\n').length;
}

/**
 * Analyze type complexity and usage patterns
 */
function analyzeTypeComplexity(typeExports, usages) {
  const analysis = {
    totalTypes: typeExports.length,
    usageDistribution: {},
    complexity: {}
  };

  // Analyze usage distribution
  const usageCounts = usages.map(u => u.usageCount);
  if (usageCounts.length > 0) {
    analysis.usageDistribution = {
      min: Math.min(...usageCounts),
      max: Math.max(...usageCounts),
      average: usageCounts.reduce((a, b) => a + b, 0) / usageCounts.length,
      median: usageCounts.sort((a, b) => a - b)[Math.floor(usageCounts.length / 2)]
    };
  }

  // Analyze complexity (rough estimate based on name patterns)
  const complexPatterns = typeExports.filter(t =>
    t.name.includes('Config') ||
    t.name.includes('Options') ||
    t.name.includes('Props') ||
    t.name.includes('State') ||
    t.name.length > 20
  );

  analysis.complexity = {
    simpleTypes: typeExports.length - complexPatterns.length,
    complexTypes: complexPatterns.length,
    complexityRatio: complexPatterns.length / typeExports.length
  };

  return analysis;
}

/**
 * Main function
 */
async function main() {
  console.log('🔍 AIRules Ontology - Type Usage Analysis');
  console.log('=========================================\n');

  const rootDir = path.resolve(__dirname, '..', '..');
  const typesDir = path.join(rootDir, 'src', 'types');

  if (!fs.existsSync(typesDir)) {
    console.error('❌ ERROR: types directory not found:', typesDir);
    console.error('   This tool analyzes TypeScript types in src/types/ directory.');
    console.error('   Make sure your project has TypeScript types to analyze.');
    process.exit(1);
  }

  console.log('📂 Analyzing TypeScript types...\n');

  // Find all type files
  const typeFiles = findTypeFiles(typesDir);

  if (typeFiles.length === 0) {
    console.warn('⚠️ No TypeScript files found in types directory');
    console.warn('   Make sure you have .ts files with type definitions');
    process.exit(0);
  }

  console.log(`📄 Found ${typeFiles.length} type files:`);
  typeFiles.forEach(file => {
    console.log(`   └─ ${path.relative(rootDir, file)}`);
  });
  console.log('');

  // Parse each file
  const allTypes = [];
  let totalTypeExports = 0;

  typeFiles.forEach(file => {
    const typeInfo = parseTypeFile(file);

    if (typeInfo && typeInfo.typeExports.length > 0) {
      console.log(`📋 ${typeInfo.fileName}: ${typeInfo.typeExports.length} exports`);

      // For each exported type, find usages
      typeInfo.typeExports.forEach(typeExport => {
        const usages = findTypeUsages(typeExport.name, rootDir);

        const typeData = {
          name: typeExport.name,
          kind: typeExport.type,
          fileName: typeInfo.fileName,
          filePath: path.relative(rootDir, typeInfo.filePath),
          line: typeExport.line,
          usageCount: usages.length,
          usages: usages.slice(0, 10), // Limit to first 10 usages
          isUsed: usages.length > 0
        };

        allTypes.push(typeData);
        totalTypeExports++;

        // Log usage info
        if (usages.length > 0) {
          console.log(`   ✅ ${typeExport.name} (${typeExport.type}): used in ${usages.length} files`);
        } else {
          console.log(`   ⚠️ ${typeExport.name} (${typeExport.type}): not used`);
        }
      });
    } else {
      console.log(`📋 ${path.basename(file)}: no exports found`);
    }
  });

  console.log(`\n📊 Total types analyzed: ${totalTypeExports}`);

  if (allTypes.length === 0) {
    console.warn('⚠️ No type exports found in the project');
    console.warn('   Make sure your types are properly exported with "export type" or "export interface"');
    process.exit(0);
  }

  // Analyze usage patterns
  const usedTypes = allTypes.filter(t => t.isUsed);
  const unusedTypes = allTypes.filter(t => !t.isUsed);

  console.log(`\n📈 Usage Statistics:`);
  console.log(`   ✅ Used types: ${usedTypes.length}`);
  console.log(`   ⚠️ Unused types: ${unusedTypes.length}`);
  console.log(`   📊 Usage rate: ${((usedTypes.length / allTypes.length) * 100).toFixed(1)}%`);

  // Analyze complexity
  const complexityAnalysis = analyzeTypeComplexity(allTypes, usedTypes);

  console.log(`\n🔬 Complexity Analysis:`);
  console.log(`   📏 Simple types: ${complexityAnalysis.complexity.simpleTypes}`);
  console.log(`   🧩 Complex types: ${complexityAnalysis.complexity.complexTypes}`);
  console.log(`   📊 Complexity ratio: ${(complexityAnalysis.complexity.complexityRatio * 100).toFixed(1)}%`);

  if (complexityAnalysis.usageDistribution.average) {
    console.log(`\n📊 Usage Distribution:`);
    console.log(`   📉 Min usage: ${complexityAnalysis.usageDistribution.min}`);
    console.log(`   📊 Average usage: ${complexityAnalysis.usageDistribution.average.toFixed(1)}`);
    console.log(`   📈 Max usage: ${complexityAnalysis.usageDistribution.max}`);
  }

  // Show unused types
  if (unusedTypes.length > 0) {
    console.log(`\n⚠️ Unused Types (${unusedTypes.length}):`);
    unusedTypes.slice(0, 10).forEach(type => {
      console.log(`   └─ ${type.name} (${type.kind}) in ${type.fileName}:${type.line}`);
    });

    if (unusedTypes.length > 10) {
      console.log(`   ... and ${unusedTypes.length - 10} more`);
    }
  }

  // Show most used types
  const mostUsed = usedTypes.sort((a, b) => b.usageCount - a.usageCount).slice(0, 5);
  if (mostUsed.length > 0) {
    console.log(`\n🏆 Most Used Types:`);
    mostUsed.forEach((type, i) => {
      console.log(`   ${i + 1}. ${type.name} (${type.kind}): ${type.usageCount} usages`);
    });
  }

  // Create report
  const report = {
    timestamp: new Date().toISOString(),
    project: {
      name: path.basename(rootDir),
      root: rootDir,
      analyzer: 'airules-ontology-types'
    },
    summary: {
      totalFiles: typeFiles.length,
      totalTypes: allTypes.length,
      usedTypes: usedTypes.length,
      unusedTypes: unusedTypes.length,
      usageRate: (usedTypes.length / allTypes.length) * 100,
      ...complexityAnalysis
    },
    types: allTypes.sort((a, b) => b.usageCount - a.usageCount), // Sort by usage
    unusedTypes: unusedTypes.map(t => ({
      name: t.name,
      kind: t.kind,
      file: t.fileName,
      line: t.line
    }))
  };

  // Ensure docs directory exists
  const docsDir = path.join(rootDir, 'docs');
  if (!fs.existsSync(docsDir)) {
    fs.mkdirSync(docsDir, { recursive: true });
  }

  const reportPath = path.join(docsDir, 'TYPES_REPORT.json');
  fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));

  console.log(`\n📄 Report saved: ${reportPath}`);
  console.log(`\n💡 Usage:`);
  console.log(`   📖 View report: open docs/TYPES_REPORT.json in VS Code`);
  console.log(`   🔍 Search types: grep by name or file in the JSON`);
  console.log(`   📊 Visualize: use JSON-to-table tools for analysis`);

  console.log(`\n✅ Type analysis completed successfully!`);
}

main().catch(err => {
  console.error('❌ Error:', err.message);
  console.error(err.stack);
  process.exit(1);
});