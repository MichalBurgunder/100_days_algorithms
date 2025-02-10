using System;

class Comparison {
    public static bool is_prop(string s) {
        return s.Length == 0 || (s[s.Length-1] != 'T' && s[s.Length-1] != 'F');
    }
}

class ConditionCollector {

    private Condition[] conditions = [];
    private Condition alpha_memories = [];
    private BetaNode[] beta_nodes = [];

    public Condition get_condition(string condition_name) {
        for(int i = 0; i < conditions.Length; i++) {
            if(conditions[i].name == condition_name) {
                return conditions[i];
            }
        }
        throw new Exception("condition does not exist");
    }

    private void add_beta_node(BetaNode bn) {
        beta_nodes.Append(bn);
    }

    public collect_conditions(ConditionCollector cc, string[] lines) {
        int i = 0;
        Condition current_condition = "";

        while(i < lines.Length) {
            if(!is_prop(lines[i])) {
                // it's a new condition
                Condition current_condition = new Condition(lines[i], cc);
                i++;
                while(true) {
                    if(is_prop(lines[i])){
                        current_condition.add_prop(lines[i]);
                        i++;
                    } else {
                        break;
                    }
                }
                if(current_condition.is_alpha()) {
                    this.alpha_memories.Append(current_condition)
                }
            }
            // rogue line; report!
            throw new Exception("rogue line detected")
        }
    }

    public Condition[] apply_beta_nodes() {
        Condition[] all_beta_nodes = [];

        for(int i=0; i < this.beta_nodes; i++) {
            this.beta_nodes[i].set_state();
            if(this.beta_nodes[i].get_state()) {
                all_beta_nodes.Append(this.beta_nodes[i]);
            }
        }
        return all_beta_nodes
    }

    public void create_beta_nodes(string[] lines) {
        int i = 0;

        while(i < lines.Length) {
            if(!is_prop(lines[i])) {
                // it's a new Beta node
                Condition beta_node = new Condition(this, cc, true);
                beta_nodes.Append(beta_node)

                i++;
                while(true) {
                    if(is_prop(lines[i])){
                        Condition condition = cc.get_condition(lines[i]);
                        beta_node.add_conditon(condition);
                        i++;
                    } else {
                        break;
                    }
                }
            }
            // rogue line; report!
            throw new Exception("rogue line detected in beta creation")
        }
    }
}

class Condition {

    private int test_int;
    private ConditionCollector cc;
    private Condition[] list_of_conditions = [];
    private bool is_beta_node = false;
    private bool state = null;

    public Condition(string name, ConditionCollector cc, bool is_beta = false) {
        this.name = name;
        if(!is_beta) {
            this.cc = cc;
        } else {
            cc.add_beta_node(this)
        }
             
    }

    public void add_prop(new_cond) {
        if(is_beta_node) {
            throw new Exception("can't add conditions to beta node");
        }

        Condition new_condition = this.cc.get_prop(new_cond);
        if(!new_condition) {
            new_condition = new Condition(new_cond, this.cc)
        }
        list_of_conditions.Append(new_condition);
    }

    public bool is_alpha() {
        return list_of_conditions.Length == 0
    }

    public bool set_state() {
        if(this.state != null) {
            return this.state
        }

        if(!is_beta_node) {
            throw new Exception("can't set state of a non-beta node")
        }

        for(int i=0;i<list_of_conditions.Length;i++) {
            bool state = list_of_conditions.set_state();
            if(!state) {
                this.state = false
                return false
            }
        }
        this.state = true
        return true
    }
}

class ReteAlgorithm {
    static void Main() {
        // See https://aka.ms/new-console-template for more information
        ConditionCollector cc = new ConditionCollector()

        string[] lines = File.ReadAllLines("select_nodes.txt");
        cc.collect_conditions(cc, lines)

        string[] lines = File.ReadAllLines("beta_nodes.txt");
        cc.create_beta_nodes(lines)
        string[] betanodes = cc.apply_beta_nodes(cc, lines);

        for(int i=0; i<betanodes.Length;i++) {
            Console.WriteLine(betanodes.get_name())
        }
    }
}
