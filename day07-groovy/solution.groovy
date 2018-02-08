def parseGraph(String fileName) { 
    def graph = new HashMap()
    new File(fileName).eachLine { text ->
        def (_, label, weight) = (text =~ /(\w+) \((\d+)\)/)[0]
        def chm = (text =~ /-> (.*)$/)
        def children = (chm.count > 0) ? chm[0][1].split(', ') : [];
        graph[label] = [weight.toInteger(), children]
    }
    graph
}

def findRoot(HashMap graph) {
    def nonRoot = new HashSet(graph.collect {it.value[1]}.flatten())
    graph.collect {it.key}.findAll {!(it in nonRoot)}[0]
}

def findBalanceAmt(HashMap graph) {
    def balanceAmt = 0
    def getTotalWeight
    
    getTotalWeight = { node ->
        def (weight, children) = graph[node]
        if (!children) return weight

        def chw = children.collect {getTotalWeight it}        
        def (minw, maxw) = [chw.min(), chw.max()]
        def deltaw = 0

        if (minw != maxw) {
            //  find the outlier location
            def outlierIdx = -1
            if (chw.collect {it == minw}.size() == 1) {
                outlierIdx = chw.findIndexOf{it == minw}
                deltaw = maxw - minw
            } else {
                outlierIdx = chw.findIndexOf{it == maxw}
                deltaw = minw - maxw
            }
            balanceAmt = graph[children[outlierIdx]][0] + deltaw
        }
        weight + chw.sum(0) + deltaw
    }

    getTotalWeight(findRoot(graph))
    balanceAmt
}

def graph = parseGraph('input.txt')
println "Part 1: " + findRoot(graph)
println "Part 2: " + findBalanceAmt(graph)
