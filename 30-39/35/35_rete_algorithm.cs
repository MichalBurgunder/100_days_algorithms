using System;

class Comparison {
    public static bool is_prop(string s) {
        return s.Length == 0 || (s[s.Length-1] != 'T' && s[s.Length-1] != 'F');
    }
}

class ConditionCollector {

    private List<Condition> conditions = [];
    private List<Condition> alpha_memories = [];
    private List<Condition> beta_nodes = [];

    public Condition get_condition(string condition_name) {
        for(int i = 0; i < conditions.Count; i++) {
            if(conditions[i].name == condition_name) {
                return conditions[i];
            }
        }
        throw new Exception("condition does not exist");
    }

        public Condition? condition_exists(string condition_name) {
            for(int i = 0; i < conditions.Count; i++) {
                if(conditions[i].name == condition_name) {
                    return conditions[i];
                }
            }
            return false;
    }

    public void add_beta_node(Condition bn) {
        beta_nodes.Append(bn);
    }

    public void collect_conditions(ConditionCollector cc, string[] lines) {
        int i = 0;
        Condition current_condition;

        while(i < lines.Length) {
            if(!Comparison.is_prop(lines[i])) {
                // it's a new condition
                current_condition = new Condition(lines[i].Substring(0, lines[i].Length-2), cc);
                i++;
                while(true) {
                    if(Comparison.is_prop(lines[i])){
                        current_condition.add_prop(lines[i]);
                        i++;
                    } else {
                        break;
                    }
                }
                if(current_condition.is_alpha()) {
                    this.alpha_memories.Add(current_condition);
                }
            }
            // rogue line; report!
            throw new Exception("rogue line detected");
        }
    }

    public List<Condition> apply_beta_nodes() {
        List<Condition> all_beta_nodes = [];

        for(int i=0; i < this.beta_nodes.Count; i++) {
            this.beta_nodes[i].set_state();
            if(this.beta_nodes[i].get_state()) {
                all_beta_nodes.Add(this.beta_nodes[i]);
            }
        }
        return all_beta_nodes;
    }

    public void create_beta_nodes(string[] lines) {
        int i = 0;

        while(i < lines.Length) {
            if(!Comparison.is_prop(lines[i])) {
                // it's a new Beta node
                Condition beta_node = new Condition(lines[i], this, true);
                beta_nodes.Append(beta_node);

                i++;
                while(true) {
                    if(Comparison.is_prop(lines[i])){
                        Condition condition = this.get_condition(lines[i]);
                        beta_nodes.add_condition(condition);
                        i++;
                    } else {
                        break;
                    }
                }
            }
            // rogue line; report!
            throw new Exception("rogue line detected in beta creation");
        }
    }
}

class Condition {

    private ConditionCollector cc;
    private List<Condition> list_of_conditions = [];
    private bool is_beta_node = false;
    private bool? state;
    public string name;

    public string get_name() {
        return this.name;
    }

    public Condition(string name, ConditionCollector? cc, bool is_beta = false) {
        this.name = name;

        if(!is_beta) {
            this.cc = cc;
        } else {
            cc.add_beta_node(this);
        }      
    }

    public void add_prop(string new_cond) {
        if(this.is_beta_node) {
            throw new Exception("can't add conditions to beta node");
        }

        Condition new_condition = this.cc.condition_exists(new_cond);
        if(new_condition == null) {
            new_condition = new Condition(new_cond, this.cc);
        }
        list_of_conditions.Append(new_condition);
    }

    public bool is_alpha() {
        return this.list_of_conditions.Count == 0;
    }

    public bool set_state() {
        if(this.state != null) {
            return this.state;
        }

        if(!is_beta_node) {
            throw new Exception("can't set state of a non-beta node");
        }


        for(int i=0;i<this.list_of_conditions.Count;i++) {
            bool state = this.list_of_conditions[i].set_state();
            if(!state) {
                this.state = false;
                return false;
            }
        }
        this.state = true;
        return true;
    }
}

class ReteAlgorithm {
    static void Main() {
        // See https://aka.ms/new-console-template for more information
        ConditionCollector cc = new ConditionCollector();

        string[] lines = File.ReadAllLines("select_nodes.txt");
        cc.collect_conditions(cc, lines);

        string[] lines_beta = File.ReadAllLines("beta_nodes.txt");
        cc.create_beta_nodes(lines_beta);

        string[] betanodes = cc.apply_beta_nodes();

        for(int i=0; i<betanodes.Count;i++) {
            Console.WriteLine(betanodes[i].get_name());
        }
    }
}
