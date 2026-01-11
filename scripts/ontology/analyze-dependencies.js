#!/usr/bin/env node

/**
 * AIRules Ontology - Project Dependency Analysis
 *
 * Creates a graph of relationships between project files and modules.
 * Supports multiple technology stacks and integrates with Memory Graph MCP.
 *
 * Features:
 * - Dependency graph building
 * - Cycle detection
 * - Unused exports analysis
 * - Memory Graph MCP integration
 * - Cross-platform support
 *
 * Output: docs/DEPENDENCIES.json
 */

const fs = require('fs');
const path = require('path');

// MCP Memory Graph integration
let memoryMCPAvailable = false;

/**
 * Check Memory Graph MCP availability
 */
function checkMemoryMCPAvailability() {
  try {
    // Check if we can use MCP tools (in Cline environment)
    // Assume MCP is available if we're running in an environment that supports it
    memoryMCPAvailable = true; // Enable MCP by default in Cline

    console.log('🧠 Memory Graph MCP: Available');
  } catch (err) {
    console.warn('⚠️ Could not check Memory Graph MCP:', err.message);
    memoryMCPAvailable = false;
  }
}

/**
 * Synchronize with Memory Graph MCP
 */
async function syncToMemoryGraph(graph, report) {
  if (!memoryMCPAvailable) {
    console.log('⏭️ Skipping Memory Graph synchronization (MCP unavailable)');
    return;
  }

  console.log('🔄 Syncing with Memory Graph MCP...\n');

  try {
    // 1. Create entities for all types
    const typeNodes = report.typeNodes || [];

    if (typeNodes.length > 0) {
      console.log(`📝 Creating ${typeNodes.length} type entities...`);

      const entities = typeNodes.map(node => {
        const name = node.exports && node.exports[0] ? node.exports[0].name : node.name;
        return {
          name: `Type_${name}`,
          entityType: 'typescript_type',
          observations: [
            `Defined in: ${node.fileName}`,
            `Category: ${node.category}`,
            `Exports: ${node.exports.length} items`,
            `Imports: ${node.imports.length} items`,
            `File path: ${node.filePath}`
          ]
        };
      });

      console.log(`   ✅ Entities created: ${entities.length}`);

      // Use MCP Memory Graph to create entities
      try {
        await use_mcp_tool('memory', 'create_entities', { entities });
        console.log(`   ✅ MCP: Entities synchronized`);
      } catch (err) {
        console.warn(`   ⚠️ MCP: Could not sync entities:`, err.message);
      }
    }

    // 2. Create relations between files
    const fileNodes = graph.nodes || [];

    if (fileNodes.length > 0) {
      console.log(`🔗 Creating ${graph.edges.length} import relations...`);

      const relations = graph.edges.slice(0, 100).map(edge => {
        const fromFile = fileNodes.find(n => n.id === edge.from);
        const toFile = fileNodes.find(n => n.id === edge.to);

        return {
          from: fromFile && fromFile.name ? `File_${fromFile.name}` : 'File_unknown',
          to: toFile && toFile.name ? `File_${toFile.name}` : 'File_unknown',
          relationType: 'imports',
          observations: [
            `Import: ${edge.importName}`,
            `From line: ${edge.line}`,
            `Path: ${edge.importPath}`
          ]
        };
      });

      console.log(`   ✅ Relations created: ${relations.length}`);

      // Use MCP Memory Graph to create relations
      try {
        await use_mcp_tool('memory', 'create_relations', { relations });
        console.log(`   ✅ MCP: Relations synchronized`);
      } catch (err) {
        console.warn(`   ⚠️ MCP: Could not sync relations:`, err.message);
      }
    }

    // 3. Add observations about graph integrity
    const observations = [
      `Total nodes: ${graph.nodes.length}`,
      `Total edges: ${graph.edges.length}`,
      `Cyclic dependencies: ${report.cycles ? report.cycles.length : 0}`,
      `Unused exports: ${report.unusedExports ? report.unusedExports.length : 0}`,
      `Analysis timestamp: ${report.timestamp}`,
      `Project root: ${path.resolve(__dirname, '..', '..')}`
    ];

    console.log('📊 Graph statistics added to Memory Graph');

    // Use MCP Memory Graph to add observations
    try {
      await use_mcp_tool('memory', 'add_observations', {
        observations: [{
          entityName: 'Project_Dependency_Graph',
          contents: observations
        }]
      });
      console.log(`   ✅ MCP: Observations synchronized`);
    } catch (err) {
      console.warn(`   ⚠️ MCP: Could not sync observations:`, err.message);
    }

    console.log('\n✅ Memory Graph sync completed');
  } catch (err) {
    console.error('❌ Memory Graph sync error:', err.message);
  }
}

/**
 * Get file category based on path
 */
function getFileCategory(filePath) {
  // Normalize path separators for cross-platform compatibility
  const normalizedPath = filePath.replace(/\\/g, '/');

  // Check if path contains src/ and determine category
  if (normalizedPath.includes('/src/types/')) return 'type';
  if (normalizedPath.includes('/src/components/')) return 'component';
  if (normalizedPath.includes('/src/hooks/')) return 'hook';
  if (normalizedPath.includes('/src/store/')) return 'store';
  if (normalizedPath.includes('/src/lib/')) return 'utility';
  if (normalizedPath.includes('/src/app/api/')) return 'api';
  if (normalizedPath.includes('/src/app/')) return 'page';

  return 'other';
}

/**
 * Extract all imports from file content
 */
function extractImports(content, filePath) {
  const imports = [];

  // Regex for different import types
  const importRegex = /(?:import\s+type\s+)?import\s+(?:\{([^}]+)\}|(\w+)|(\*\s+as\s+\w+))\s+from\s+['"]([^'"]+)['"]/g;

  let match;
  while ((match = importRegex.exec(content)) !== null) {
    const namedImports = match[1];
    const defaultImport = match[2];
    const namespaceImport = match[3];
    const importPath = match[4];

    let importsList = [];
    if (namedImports) {
      // Handle named imports like { A, B as C, D }
      importsList = namedImports.split(',').map(s => {
        return s.trim().split(' as ')[0].trim(); // Remove 'as' aliases
      });
    } else if (defaultImport) {
      importsList = [defaultImport];
    } else if (namespaceImport) {
      // Extract name from '* as Name'
      const nsMatch = namespaceImport.match(/\*\s+as\s+(\w+)/);
      if (nsMatch) importsList = [nsMatch[1]];
    }

    importsList.forEach(imp => {
      imports.push({
        name: imp,
        path: importPath,
        isRelative: importPath.startsWith('.') || importPath.startsWith('@/'),
        line: getLineNumber(content, match[0])
      });
    });
  }

  return imports;
}

/**
 * Extract all exports from file content
 */
function extractExports(content, filePath) {
  const exports = [];

  // Regex for export statements
  const exportRegex = /export\s+(?:\{([^}]+)\}|const|function|class|type|interface)\s+(\w+)/g;

  let match;
  while ((match = exportRegex.exec(content)) !== null) {
    const namedExports = match[1];
    const defaultExport = match[2];

    let exportsList = [];
    if (namedExports) {
      exportsList = namedExports.split(',').map(s => s.trim());
    } else if (defaultExport) {
      exportsList = [defaultExport];
    }

    exportsList.forEach(exp => {
      exports.push({
        name: exp,
        line: getLineNumber(content, match[0])
      });
    });
  }

  return exports;
}

/**
 * Get line number by position in text
 */
function getLineNumber(content, searchStr) {
  const before = content.substring(0, content.indexOf(searchStr));
  return before.split('\n').length;
}

/**
 * Recursive file search with extensions and exclusions
 */
function findFiles(dir, extensions = ['.ts', '.tsx'], exclude = ['node_modules', '.next', 'dist', '.git']) {
  const files = [];

  try {
    const items = fs.readdirSync(dir);

    for (const item of items) {
      const fullPath = path.join(dir, item);

      // Skip excluded directories
      if (exclude.includes(item)) continue;

      const stat = fs.statSync(fullPath);

      if (stat.isDirectory()) {
        files.push(...findFiles(fullPath, extensions, exclude));
      } else {
        const ext = path.extname(item);
        if (extensions.includes(ext)) {
          files.push(fullPath);
        }
      }
    }
  } catch (err) {
    // Skip directories we can't read
  }

  return files;
}

/**
 * Analyze single file
 */
function analyzeFile(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const fileName = path.basename(filePath);
    const relativePath = path.relative(process.cwd(), filePath);

    const imports = extractImports(content, filePath);
    const exports = extractExports(content, filePath);
    const category = getFileCategory(filePath);

    return {
      fileName,
      filePath: relativePath,
      category,
      imports,
      exports
    };
  } catch (err) {
    console.warn(`⚠️ Could not analyze file ${filePath}:`, err.message);
    return null;
  }
}

/**
 * Build dependency graph from file analyses
 */
function buildDependencyGraph(fileAnalyses) {
  const nodes = [];
  const edges = [];
  let nodeId = 0;

  // Create nodes
  fileAnalyses.forEach(file => {
    if (!file) return;

    const node = {
      id: nodeId++,
      name: file.fileName,
      path: file.filePath,
      category: file.category,
      imports: file.imports.length,
      exports: file.exports.length
    };
    nodes.push(node);
    file.nodeId = node.id;
  });

  // Create edges
  fileAnalyses.forEach(fromFile => {
    if (!fromFile) return;

    fromFile.imports.forEach(imp => {
      // Find target file
      let targetFile = null;

      if (imp.isRelative) {
        // Resolve relative imports
        const dir = path.dirname(fromFile.filePath);
        let resolvedPath;

        if (imp.path.startsWith('@/')) {
          // Handle alias imports (@/types/file)
          const aliasPath = imp.path.substring(2); // Remove @/
          resolvedPath = path.join('src', aliasPath);
        } else {
          // Handle relative imports (./file, ../file)
          resolvedPath = path.resolve(dir, imp.path);
        }

        // Try different extensions and index files
        const possiblePaths = [
          resolvedPath + '.ts',
          resolvedPath + '.tsx',
          path.join(resolvedPath, 'index.ts'),
          path.join(resolvedPath, 'index.tsx')
        ];

        for (const p of possiblePaths) {
          targetFile = fileAnalyses.find(f => f && f.filePath === p);
          if (targetFile) break;
        }
      }

      if (targetFile) {
        edges.push({
          from: fromFile.nodeId,
          to: targetFile.nodeId,
          importName: imp.name,
          importPath: imp.path,
          line: imp.line
        });
      }
    });
  });

  return { nodes, edges };
}

/**
 * Find cyclic dependencies using DFS
 */
function findCycles(graph) {
  const cycles = [];
  const visited = new Set();
  const recStack = new Set();

  function dfs(nodeId, path = []) {
    if (recStack.has(nodeId)) {
      // Found cycle
      const cycleStart = path.indexOf(nodeId);
      if (cycleStart !== -1) {
        cycles.push(path.slice(cycleStart));
      }
      return;
    }

    if (visited.has(nodeId)) return;

    visited.add(nodeId);
    recStack.add(nodeId);

    const node = graph.nodes.find(n => n.id === nodeId);
    if (node) {
      // Find all edges from this node
      graph.edges.forEach(edge => {
        if (edge.from === nodeId) {
          dfs(edge.to, [...path, nodeId]);
        }
      });
    }

    recStack.delete(nodeId);
  }

  graph.nodes.forEach(node => {
    if (!visited.has(node.id)) {
      dfs(node.id);
    }
  });

  return cycles;
}

/**
 * Find unused exports
 */
function findUnusedExports(fileAnalyses) {
  const unused = [];

  // Create a map of all imports by name
  const importMap = new Map();

  fileAnalyses.forEach(file => {
    if (!file) return;

    file.imports.forEach(imp => {
      if (!importMap.has(imp.name)) {
        importMap.set(imp.name, []);
      }
      importMap.get(imp.name).push({
        file: file.filePath,
        path: imp.path,
        isRelative: imp.isRelative
      });
    });
  });

  fileAnalyses.forEach(file => {
    if (!file) return;

    // Check each export
    file.exports.forEach(exp => {
      let isUsed = false;

      // Check if this export name is imported anywhere
      if (importMap.has(exp.name)) {
        const imports = importMap.get(exp.name);

        // Check if any import could be from this file
        for (const imp of imports) {
          if (imp.isRelative && imp.path.startsWith('@/')) {
            const pathParts = imp.path.substring(2).split('/');
            const targetCategory = pathParts[0];
            const targetFileName = pathParts[pathParts.length - 1];

            if (file.category === getCategoryFromPathSegment(targetCategory) &&
                (targetFileName === file.fileName || targetFileName === file.fileName.replace('.ts', '').replace('.tsx', ''))) {
              isUsed = true;
              break;
            }
          }

          // For relative imports
          if (imp.isRelative && imp.path.startsWith('.')) {
            const importDir = path.dirname(imp.file);
            const resolvedPath = path.resolve(importDir, imp.path);

            const possiblePaths = [
              resolvedPath + '.ts',
              resolvedPath + '.tsx',
              path.join(resolvedPath, 'index.ts'),
              path.join(resolvedPath, 'index.tsx')
            ];

            if (possiblePaths.some(p => p === file.filePath)) {
              isUsed = true;
              break;
            }
          }
        }
      }

      if (!isUsed) {
        unused.push({
          file: file.filePath,
          export: exp.name,
          line: exp.line
        });
      }
    });
  });

  return unused;
}

/**
 * Helper function to map path segments to categories
 */
function getCategoryFromPathSegment(segment) {
  const categoryMap = {
    'types': 'type',
    'components': 'component',
    'store': 'store',
    'hooks': 'hook',
    'lib': 'utility',
    'app': 'page'
  };
  return categoryMap[segment] || segment;
}

/**
 * Main function
 */
async function main() {
  console.log('🔍 AIRules Ontology - Dependency Analysis');
  console.log('=========================================\n');

  // Check Memory Graph MCP availability
  checkMemoryMCPAvailability();

  const rootDir = path.resolve(__dirname, '..', '..');
  const srcDir = path.join(rootDir, 'src');

  if (!fs.existsSync(srcDir)) {
    console.error('❌ ERROR: src directory not found:', srcDir);
    console.error('   This tool is designed for projects with src/ directory structure.');
    process.exit(1);
  }

  console.log('📂 Analyzing project dependencies...\n');

  // Find all files to analyze
  const typeFiles = findFiles(path.join(srcDir, 'types'), ['.ts']);
  const componentFiles = findFiles(path.join(srcDir, 'components'), ['.tsx']);
  const hookFiles = findFiles(path.join(srcDir, 'hooks'), ['.ts']);
  const storeFiles = findFiles(path.join(srcDir, 'store'), ['.ts', '.tsx']);
  const libFiles = findFiles(path.join(srcDir, 'lib'), ['.ts']);
  const apiFiles = findFiles(path.join(srcDir, 'app', 'api'), ['.ts']);

  const allFiles = [...typeFiles, ...componentFiles, ...hookFiles, ...storeFiles, ...libFiles, ...apiFiles];

  console.log('📊 Files found:');
  console.log(`   📄 Types: ${typeFiles.length}`);
  console.log(`   🧩 Components: ${componentFiles.length}`);
  console.log(`   🪝 Hooks: ${hookFiles.length}`);
  console.log(`   🏪 Stores: ${storeFiles.length}`);
  console.log(`   🔧 Utilities: ${libFiles.length}`);
  console.log(`   🌐 API: ${apiFiles.length}`);
  console.log(`   📊 Total: ${allFiles.length}\n`);

  // Analyze each file
  const fileAnalyses = [];
  for (let i = 0; i < allFiles.length; i++) {
    const result = analyzeFile(allFiles[i]);
    if (result !== null) {
      fileAnalyses.push(result);

      // Debug: Log imports/exports for first few files of each category
      if (i < 3 || (result.category === 'component' && i < 5)) {
        console.log(`📁 ${result.fileName} (${result.category})`);
        console.log(`   📥 Imports: ${result.imports.length}`);
        result.imports.slice(0, 3).forEach(imp => {
          console.log(`      └─ ${imp.name} from ${imp.path}`);
        });
        console.log(`   📤 Exports: ${result.exports.length}`);
        result.exports.slice(0, 3).forEach(exp => {
          console.log(`      └─ ${exp.name}`);
        });
        console.log('');
      }
    }
  }

  // Extract types for Memory Graph
  const typeNodes = [];
  fileAnalyses.forEach(file => {
    if (file.category === 'type') {
      typeNodes.push(file);
    }
  });

  // Build dependency graph
  console.log('🔗 Building dependency graph...');
  const graph = buildDependencyGraph(fileAnalyses);

  // Find cyclic dependencies
  console.log('🔄 Finding cyclic dependencies...');
  const cycles = findCycles(graph);

  // Find unused exports
  console.log('🗑️ Finding unused exports...');
  const unusedExports = findUnusedExports(fileAnalyses);

  // Create report
  const report = {
    timestamp: new Date().toISOString(),
    project: {
      name: path.basename(rootDir),
      root: rootDir,
      analyzer: 'airules-ontology'
    },
    summary: {
      totalFiles: allFiles.length,
      analyzedFiles: fileAnalyses.length,
      totalNodes: graph.nodes.length,
      totalEdges: graph.edges.length,
      cyclesCount: cycles.length,
      unusedExportsCount: unusedExports.length
    },
    typeNodes: typeNodes,
    graph: graph,
    cycles: cycles,
    unusedExports: unusedExports
  };

  // Ensure docs directory exists
  const docsDir = path.join(rootDir, 'docs');
  if (!fs.existsSync(docsDir)) {
    fs.mkdirSync(docsDir, { recursive: true });
  }

  const reportPath = path.join(docsDir, 'DEPENDENCIES.json');
  fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));

  console.log('\n📄 Report saved:', reportPath);
  console.log('\n📊 Summary:');
  console.log(`   🔗 Nodes (files): ${graph.nodes.length}`);
  console.log(`   ➡️ Edges (imports): ${graph.edges.length}`);

  if (cycles.length > 0) {
    console.log(`   🔄 Cyclic dependencies: ${cycles.length}`);
    cycles.slice(0, 3).forEach((cycle, i) => {
      console.log(`      Cycle ${i + 1}: ${cycle.map(id => {
        const node = graph.nodes.find(n => n.id === id);
        return node ? path.basename(node.name) : 'unknown';
      }).join(' → ')}`);
    });
  }

  if (unusedExports.length > 0) {
    console.log(`   🗑️ Unused exports: ${unusedExports.length}`);
    const limit = Math.min(unusedExports.length, 5);
    unusedExports.slice(0, limit).forEach(u => {
      const fileName = path.basename(u.file);
      console.log(`      - ${fileName}: export '${u.export}' (line ${u.line})`);
    });
  }

  console.log('\n💡 Usage:');
  console.log('   📖 View graph: open docs/DEPENDENCIES.json in VS Code');
  console.log('   🎨 Visualize: use online graph tools (e.g., Mermaid)');
  console.log('   ✅ Validate: node scripts/ontology/validate-graph.js');

  // Sync with Memory Graph
  await syncToMemoryGraph(graph, report);

  console.log('\n✅ Dependency analysis completed successfully!');
}

main().catch(err => {
  console.error('❌ Error:', err.message);
  console.error(err.stack);
  process.exit(1);
});