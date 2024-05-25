import{getIndentUnit as t}from"@codemirror/language";import{combineConfig as e,Facet as n,RangeSetBuilder as i}from"@codemirror/state";import{EditorView as s,Decoration as r,ViewPlugin as o}from"@codemirror/view";
/**
 * Gets the visible lines in the editor. Lines will not be repeated.
 *
 * @param view - The editor view to get the visible lines from.
 * @param state - The editor state. Defaults to the view's current one.
 */function getVisibleLines(t,e=t.state){const n=new Set;for(const{from:i,to:s}of t.visibleRanges){let t=i;while(t<=s){const i=e.doc.lineAt(t);n.has(i)||n.add(i);t=i.to+1}}return n}
/**
 * Gets the line at the position of the primary cursor.
 *
 * @param state - The editor state from which to extract the line.
 */function getCurrentLine(t){const e=t.selection.main.head;return t.doc.lineAt(e)}
/**
 * Returns the number of columns that a string is indented, controlling for
 * tabs. This is useful for determining the indentation level of a line.
 *
 * Note that this only returns the number of _visible_ columns, not the number
 * of whitespace characters at the start of the string.
 *
 * @param str - The string to check.
 * @param tabSize - The size of a tab character. Usually 2 or 4.
 */function numColumns(t,e){let n=0;t:for(let i=0;i<t.length;i++)switch(t[i]){case" ":n+=1;continue t;case"\t":n+=e-n%e;continue t;case"\r":continue t;default:break t}return n}const a=n.define({combine(t){return e(t,{highlightActiveBlock:true,hideFirstIndent:false,markerType:"fullScope",thickness:1})}});class IndentationMap{
/**
     * @param lines - The set of lines to get the indentation map for.
     * @param state - The {@link EditorState} to derive the indentation map from.
     * @param unitWidth - The width of the editor's indent unit.
     * @param markerType - The type of indentation to use (terminate at end of scope vs last line of code in scope)
     */
constructor(t,e,n,i){this.lines=t;this.state=e;this.map=new Map;this.unitWidth=n;this.markerType=i;for(const t of this.lines)this.add(t);this.state.facet(a).highlightActiveBlock&&this.findAndSetActiveLines()}
/**
     * Checks if the indentation map has an entry for the given line.
     *
     * @param line - The {@link Line} or line number to check for.
     */has(t){return this.map.has(typeof t==="number"?t:t.number)}
/**
     * Returns the {@link IndentEntry} for the given line.
     *
     * Note that this function will throw an error if the line does not exist in the map.
     *
     * @param line - The {@link Line} or line number to get the entry for.
     */get(t){const e=this.map.get(typeof t==="number"?t:t.number);if(!e)throw new Error("Line not found in indentation map");return e}
/**
     * Sets the {@link IndentEntry} for the given line.
     *
     * @param line - The {@link Line} to set the entry for.
     * @param col - The visual beginning whitespace width of the line.
     * @param level - The indentation level of the line.
     */set(t,e,n){const i=!t.text.trim().length;const s={line:t,col:e,level:n,empty:i};this.map.set(s.line.number,s);return s}
/**
     * Adds a line to the indentation map.
     *
     * @param line - The {@link Line} to add to the map.
     */add(t){if(this.has(t))return this.get(t);if(!t.length||!t.text.trim().length){if(t.number===1)return this.set(t,0,0);if(t.number===this.state.doc.lines){const e=this.closestNonEmpty(t,-1);return this.set(t,0,e.level)}const e=this.closestNonEmpty(t,-1);const n=this.closestNonEmpty(t,1);return e.level>=n.level&&this.markerType!=="codeOnly"?this.set(t,0,e.level):e.empty&&e.level===0&&n.level!==0?this.set(t,0,0):n.level>e.level?this.set(t,0,e.level+1):this.set(t,0,n.level)}const e=numColumns(t.text,this.state.tabSize);const n=Math.floor(e/this.unitWidth);return this.set(t,e,n)}
/**
     * Finds the closest non-empty line, starting from the given line.
     *
     * @param from - The {@link Line} to start from.
     * @param dir - The direction to search in. Either `1` or `-1`.
     */closestNonEmpty(t,e){let n=t.number+e;while(e===-1?n>=1:n<=this.state.doc.lines){if(this.has(n)){const t=this.get(n);if(!t.empty)return t}const t=this.state.doc.line(n);if(t.text.trim().length){const e=numColumns(t.text,this.state.tabSize);const n=Math.floor(e/this.unitWidth);return this.set(t,e,n)}n+=e}const i=this.state.doc.line(e===-1?1:this.state.doc.lines);return this.set(i,0,0)}findAndSetActiveLines(){const t=getCurrentLine(this.state);if(!this.has(t))return;let e=this.get(t);if(this.has(e.line.number+1)){const t=this.get(e.line.number+1);t.level>e.level&&(e=t)}if(this.has(e.line.number-1)){const t=this.get(e.line.number-1);t.level>e.level&&(e=t)}if(e.level===0)return;e.active=e.level;let n;let i;for(n=e.line.number;n>1;n--){if(!this.has(n-1))continue;const t=this.get(n-1);if(t.level<e.level)break;t.active=e.level}for(i=e.line.number;i<this.state.doc.lines;i++){if(!this.has(i+1))continue;const t=this.get(i+1);if(t.level<e.level)break;t.active=e.level}}}function indentTheme(t){const e={light:"#F0F1F2",dark:"#2B3245",activeLight:"#E4E5E6",activeDark:"#3C445C"};let n=e;t&&(n=Object.assign(Object.assign({},e),t));return s.baseTheme({"&light":{"--indent-marker-bg-color":n.light,"--indent-marker-active-bg-color":n.activeLight},"&dark":{"--indent-marker-bg-color":n.dark,"--indent-marker-active-bg-color":n.activeDark},".cm-line":{position:"relative"},".cm-indent-markers::before":{content:'""',position:"absolute",top:0,left:"2px",right:0,bottom:0,background:"var(--indent-markers)",pointerEvents:"none",zIndex:"-1"}})}function createGradient(t,e,n,i,s){const r=`repeating-linear-gradient(to right, var(${t}) 0 ${e}px, transparent ${e}px ${n}ch)`;return`${r} ${i*n}.5ch/calc(${n*s}ch - 1px) no-repeat`}function makeBackgroundCSS(t,e,n,i){const{level:s,active:r}=t;if(n&&s===0)return[];const o=n?1:0;const a=[];if(r!==void 0){const t=r-o-1;t>0&&a.push(createGradient("--indent-marker-bg-color",i,e,o,t));a.push(createGradient("--indent-marker-active-bg-color",i,e,r-1,1));r!==s&&a.push(createGradient("--indent-marker-bg-color",i,e,r,s-r))}else a.push(createGradient("--indent-marker-bg-color",i,e,o,s-o));return a.join(",")}class IndentMarkersClass{constructor(e){this.view=e;this.unitWidth=t(e.state);this.currentLineNumber=getCurrentLine(e.state).number;this.generate(e.state)}update(e){const n=t(e.state);const i=n!==this.unitWidth;i&&(this.unitWidth=n);const s=getCurrentLine(e.state).number;const r=s!==this.currentLineNumber;this.currentLineNumber=s;const o=e.state.facet(a).highlightActiveBlock&&r;(e.docChanged||e.viewportChanged||i||o)&&this.generate(e.state)}generate(t){const e=new i;const n=getVisibleLines(this.view,t);const{hideFirstIndent:s,markerType:o,thickness:c}=t.facet(a);const l=new IndentationMap(n,t,this.unitWidth,o);for(const t of n){const n=l.get(t.number);if(!(n===null||n===void 0?void 0:n.level))continue;const i=makeBackgroundCSS(n,this.unitWidth,s,c);e.add(t.from,t.from,r.line({class:"cm-indent-markers",attributes:{style:`--indent-markers: ${i}`}}))}this.decorations=e.finish()}}function indentationMarkers(t={}){return[a.of(t),indentTheme(t.colors),o.fromClass(IndentMarkersClass,{decorations:t=>t.decorations})]}export{indentationMarkers};

